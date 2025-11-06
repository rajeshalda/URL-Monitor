# URL Monitor Script
# Monitors ncmeeting.corp.nathcorp.com for availability

param(
    [string]$URL = "https://ncmeeting.corp.nathcorp.com",
    [int]$IntervalSeconds = 60,
    [string]$LogFile = "url_monitor_log.txt"
)

# Function to check URL status
function Test-URLStatus {
    param([string]$TestURL)

    try {
        $response = Invoke-WebRequest -Uri $TestURL -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop

        return @{
            Status = "UP"
            StatusCode = $response.StatusCode
            ResponseTime = $response.Headers.'X-Response-Time'
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
    }
    catch {
        return @{
            Status = "DOWN"
            StatusCode = if ($_.Exception.Response) { [int]$_.Exception.Response.StatusCode } else { "N/A" }
            Error = $_.Exception.Message
            Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        }
    }
}

# Function to log results
function Write-MonitorLog {
    param($Result, $LogPath)

    $logEntry = "$($Result.Timestamp) - Status: $($Result.Status) - StatusCode: $($Result.StatusCode)"
    if ($Result.Error) {
        $logEntry += " - Error: $($Result.Error)"
    }

    Add-Content -Path $LogPath -Value $logEntry
    return $logEntry
}

# Main monitoring loop
Write-Host "Starting URL Monitor for: $URL" -ForegroundColor Cyan
Write-Host "Check interval: $IntervalSeconds seconds" -ForegroundColor Cyan
Write-Host "Log file: $LogFile" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop monitoring`n" -ForegroundColor Yellow

$previousStatus = $null

while ($true) {
    $result = Test-URLStatus -TestURL $URL
    $logEntry = Write-MonitorLog -Result $result -LogPath $LogFile

    # Color-coded console output
    if ($result.Status -eq "UP") {
        Write-Host $logEntry -ForegroundColor Green

        # Alert if status changed from DOWN to UP
        if ($previousStatus -eq "DOWN") {
            Write-Host "ALERT: Site is now UP!" -ForegroundColor Green -BackgroundColor Black
        }
    }
    else {
        Write-Host $logEntry -ForegroundColor Red

        # Alert if status changed from UP to DOWN
        if ($previousStatus -eq "UP" -or $previousStatus -eq $null) {
            Write-Host "ALERT: Site is DOWN!" -ForegroundColor Red -BackgroundColor Black
        }
    }

    $previousStatus = $result.Status
    Start-Sleep -Seconds $IntervalSeconds
}
