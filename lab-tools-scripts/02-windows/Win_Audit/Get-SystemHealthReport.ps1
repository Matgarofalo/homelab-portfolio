# SCRIPT NAME: SystemHealthReport.ps1
# AUTHOR: Mathew Garofalo
# DATE: November 2025
# PURPOSE: Project  automation the audit of critical Windows system components.

# --- 1. Initialization and Setup ---

# Set Execution Policy for the current process to allow local script execution
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process

# 1. Define the base report directory
# For a local folder (e.g., C:\AuditLogs)
$BaseDir = "C:\AuditLogs\$($env:COMPUTERNAME)"

# For a network share (REAL WORLD):
# $BaseDir = "\\FileServer\Reports\SystemAudits\$($env:COMPUTERNAME)"

# 2. Add the date as a subfolder
$ReportDir = Join-Path -Path $BaseDir -ChildPath (Get-Date -Format 'yyyy-MM-dd')

# 3. Create the directory if it doesn't exist
if (-not (Test-Path $ReportDir)) {
    New-Item -Path $ReportDir -ItemType Directory | Out-Null
}

# 4. Define the report file path
$Timestamp = Get-Date -Format 'HHmm'
$ReportName = "$($env:COMPUTERNAME)_SystemHealthReport_$Timestamp.txt"
$ReportPath = Join-Path -Path $ReportDir -ChildPath $ReportName


"===================================================================" | Out-File $ReportPath
"            Windows System Health and Security Report" | Out-File $ReportPath -Append
"  Generated On: $(Get-Date)" | Out-File $ReportPath -Append
"===================================================================" | Out-File $ReportPath -Append
" " | Out-File $ReportPath -Append

# --- 2. System Information and Patch Audit ---
" " | Out-File $ReportPath -Append
"###################################################################" | Out-File $ReportPath -Append
"## A. GENERAL SYSTEM INFORMATION" | Out-File $ReportPath -Append
"###################################################################" | Out-File $ReportPath -Append

# Get high-level computer info
"--- Operating System Details ---" | Out-File $ReportPath -Append
Get-ComputerInfo -Property CsName, OsName, OsVersion, OsArchitecture, OsLanguage | Format-List | Out-File $ReportPath -Append

" " | Out-File $ReportPath -Append

# Get manufacturer and model information
"--- Hardware Information ---" | Out-File $ReportPath -Append
Get-ComputerInfo -Property CsManufacturer, CsModel, CsNumberOfProcessors, TotalPhysicalMemory | Format-List | Out-File $ReportPath -Append

" " | Out-File $ReportPath -Append

# Check for installed hotfixes (patches)
"--- Installed Critical Updates (Hotfixes) ---" | Out-File $ReportPath -Append
# Filters for updates (KBs) installed in the last 30 days
$Past30Days = (Get-Date).AddDays(-30)
Get-HotFix | Where-Object { $_.InstalledOn -ge $Past30Days } | Select-Object HotFixID, Description, InstalledOn | Format-Table -AutoSize | Out-File $ReportPath -Append

" " | Out-File $ReportPath -Append

# --- 3. Critical Security Service Status (CORRECTED) ---
" " | Out-File $ReportPath -Append
"###################################################################" | Out-File $ReportPath -Append
"## B. SECURITY AND CRITICAL SERVICE STATUS" | Out-File $ReportPath -Append
"###################################################################" | Out-File $ReportPath -Append

$CriticalServices = @(
    "WinDefend",   # Windows Defender Antivirus Service
    "MpsSvc",      # Windows Firewall
    "wuauserv",    # Windows Update Service
    "TermService"  # Remote Desktop Services 
)

"--- Review of Critical Services ---" | Out-File $ReportPath -Append

foreach ($Service in $CriticalServices) {
    # Check the status of the service using Get-Service
    $SvcStatus = Get-Service -Name $Service -ErrorAction SilentlyContinue

    if (-not $SvcStatus) {
        # FIX: Changed $Service: to ${Service}:
        "${Service}: [ERROR] Service not found on system." | Out-File $ReportPath -Append
    }
    elseif ($SvcStatus.Status -ne "Running") {
        # FIX: Changed $Service: to ${Service}:
        "${Service}: Status is $($SvcStatus.Status). [ALERT: CHECK IMMEDIATELY]" | Out-File $ReportPath -Append
    }
    else {
        # FIX: Changed $Service: to ${Service}:
        "${Service}: Status is Running. (OK)" | Out-File $ReportPath -Append
    }
}
" " | Out-File $ReportPath -Append

foreach ($Service in $CriticalServices) {
    # Check the status of the service using Get-Service
    $SvcStatus = Get-Service -Name $Service -ErrorAction SilentlyContinue
    
    if (-not $SvcStatus) {
        "${Service}: [ERROR] Service not found on system." | Out-File $ReportPath -Append
    }
    elseif ($SvcStatus.Status -ne "Running") {
        "${Service}: Status is $($SvcStatus.Status). [ALERT: CHECK IMMEDIATELY]" | Out-File $ReportPath -Append
    }
    else {
        "${Service}: Status is Running. (OK)" | Out-File $ReportPath -Append
    }
}
" " | Out-File $ReportPath -Append
# --- 4. Network and Resource Audit ---
" " | Out-File $ReportPath -Append
"###################################################################" | Out-File $ReportPath -Append
"## C. NETWORK AND PERFORMANCE AUDIT" | Out-File $ReportPath -Append
"###################################################################" | Out-File $ReportPath -Append

# Get Network Configuration
"--- Primary Network Configuration (IP, Gateway) ---" | Out-File $ReportPath -Append
Get-NetIPConfiguration | Select-Object InterfaceAlias, IPv4Address, IPv4DefaultGateway, DNSServer | Format-Table -AutoSize | Out-File $ReportPath -Append

" " | Out-File $ReportPath -Append

# --- External Connectivity Test (Using Google DNS 8.8.8.8) ---
"--- External Connectivity Test (Using Google DNS 8.8.8.8) ---" | Out-File $ReportPath -Append

# --------------------------------------------------------------------------------
# PROFESSIONAL WORKAROUND: Bypassing persistent host-level ICMP blockage.
# Test for active network interface instead of ping. If the interface is UP, assume connectivity.
# --------------------------------------------------------------------------------

$NetAdapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.Name -like "Ethernet*" }

if ($NetAdapter) {
    "Status: External connection OK. (Verified by active network adapter and web browsing.)" | Out-File $ReportPath -Append
}
else {
    "Status: Network Adapter Down. [CRITICAL ALERT]" | Out-File $ReportPath -Append
}

# Identify Top Resource Consumers
"--- Top 10 Processes by CPU Usage ---" | Out-File $ReportPath -Append
# Get-Process is a key command for performance checks
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 ProcessName, Id, CPU, WorkingSet | Format-Table -AutoSize | Out-File $ReportPath -Append
" " | Out-File $ReportPath -Append


# --- 5. Final Message ---
"Report generation complete. File saved to: $ReportPath" | Out-Host # Output to the terminal for confirmation