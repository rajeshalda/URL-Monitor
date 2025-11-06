# URL Monitor

A PowerShell script for monitoring website availability with real-time status updates and logging capabilities.

## Overview

This script continuously monitors a specified URL and provides color-coded console output with automatic logging. It tracks website uptime, detects status changes, and maintains a historical log of all checks.

## Features

- **Real-time Monitoring**: Continuously checks URL availability at configurable intervals
- **Color-coded Output**: Green for UP status, Red for DOWN status
- **Status Change Alerts**: Visual alerts when site status changes (UP ↔ DOWN)
- **Automatic Logging**: All checks are logged to a text file with timestamps
- **Error Handling**: Captures HTTP status codes and error messages
- **Configurable Parameters**: Customize URL, check interval, and log file location
- **Response Tracking**: Records HTTP status codes and response details

## Requirements

- Windows PowerShell 5.1 or later
- Network access to the target URL
- Write permissions for log file creation

## Usage

### Basic Usage

Run with default settings (monitors default URL every 60 seconds):

```powershell
.\Monitor-URL.ps1
```

### Custom URL

Monitor a specific URL:

```powershell
.\Monitor-URL.ps1 -URL "https://example.com"
```

### Custom Check Interval

Check every 30 seconds:

```powershell
.\Monitor-URL.ps1 -IntervalSeconds 30
```

### Custom Log File

Specify a custom log file location:

```powershell
.\Monitor-URL.ps1 -LogFile "C:\Logs\my_monitor.log"
```

### Combined Parameters

```powershell
.\Monitor-URL.ps1 -URL "https://example.com" -IntervalSeconds 120 -LogFile "monitor.log"
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `URL` | string | `https://ncmeeting.corp.nathcorp.com` | The URL to monitor |
| `IntervalSeconds` | int | `60` | Time between checks in seconds |
| `LogFile` | string | `url_monitor_log.txt` | Path to the log file |

## Output

### Console Output

The script displays real-time status information in the console:

- **Cyan**: Script startup information
- **Green**: Successful checks (Status: UP)
- **Red**: Failed checks (Status: DOWN)
- **Yellow**: User instructions
- **Highlighted Alerts**: Status change notifications

### Log File Format

Each log entry includes:
- Timestamp (yyyy-MM-dd HH:mm:ss)
- Status (UP/DOWN)
- HTTP Status Code
- Error message (if applicable)

Example log entries:
```
2025-11-06 10:39:05 - Status: UP - StatusCode: 200
2025-11-06 10:40:05 - Status: DOWN - StatusCode: 503 - Error: Service Unavailable
```

## How It Works

1. **Initialization**: Starts with user-specified or default parameters
2. **URL Check**: Sends HTTP request with 10-second timeout
3. **Status Evaluation**: Determines if site is UP or DOWN based on response
4. **Logging**: Writes result to log file and displays in console
5. **Alert Detection**: Compares current status with previous check
6. **Wait**: Sleeps for specified interval before next check
7. **Loop**: Repeats from step 2 indefinitely

## Stopping the Monitor

Press `Ctrl+C` to stop the monitoring script at any time.

## Use Cases

- **Website Uptime Monitoring**: Track website availability over time
- **Incident Detection**: Get immediate alerts when a site goes down
- **Maintenance Verification**: Monitor site status during maintenance windows
- **SLA Compliance**: Document uptime for service level agreements
- **Network Troubleshooting**: Identify connectivity issues

## Technical Details

- Uses `Invoke-WebRequest` with basic parsing for efficiency
- 10-second timeout per request to prevent hanging
- Captures both successful responses and error conditions
- Tracks status changes to minimize alert noise
- Thread-safe logging with `Add-Content`

## Troubleshooting

**Script won't run:**
- Check PowerShell execution policy: `Get-ExecutionPolicy`
- If needed, set policy: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

**Permission errors:**
- Ensure write permissions for the log file directory
- Try specifying an explicit log file path with `-LogFile`

**Network errors:**
- Verify network connectivity to target URL
- Check firewall settings
- Ensure proxy settings if applicable

**SSL/TLS errors:**
- Target URL may have certificate issues
- Consider adding certificate validation bypass for internal URLs (not recommended for production)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

rajeshalda

## Contributing

Contributions, issues, and feature requests are welcome.

## Changelog

### Version 1.0
- Initial release
- Basic URL monitoring functionality
- Logging and console output
- Status change detection
