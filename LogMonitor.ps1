# Define log file path inside the SE project folder
$logType = "System"
$logFile = "C:\Users\tarak\OneDrive\Desktop\SE project\EventLogMonitor.log"
$smtpServer = "smtp.archita.sva@gmail.com"
$fromEmail = "archita.sva@gmail.com"
$toEmail = "tarakkhurana29@gmail.com, tarakkhurana292005@gmail.com"

# Function to fetch critical logs
function Get-CriticalLogs {
    param([int]$eventID = 1000)
    Get-EventLog -LogName $logType -Newest 10 | Where-Object { $_.EntryType -eq "Error" -or $_.EntryType -eq "Critical" }
}

# Function to write logs to file
function Write-Log {
    param([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -Append -FilePath $logFile
}

# Function to send email alerts
function Send-Alert {
    param([string]$message)
    Send-MailMessage -SmtpServer $smtpServer -From $fromEmail -To $toEmail -Subject "Critical Event Alert" -Body $message
}

# Fetch critical logs
$logs = Get-CriticalLogs
if ($logs) {
    foreach ($log in $logs) {
        $logMessage = "Event ID: $($log.EventID), Source: $($log.Source), Message: $($log.Message)"
        Write-Log $logMessage
        Send-Alert $logMessage
    }
} else {
    Write-Log "No critical errors detected."
}
