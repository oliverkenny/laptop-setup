# Final Setup Tasks and Cleanup
# -----------------------------
# This script performs final setup tasks and provides next steps

Write-Host "=== Final Setup and Next Steps ===" -ForegroundColor Cyan

# Refresh environment variables
Write-Host "Refreshing environment variables..." -ForegroundColor Yellow
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Check for pending reboots
Write-Host "`nChecking system state..." -ForegroundColor Yellow
$pendingReboot = $false

# Check Windows Update reboot flag
if (Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -ErrorAction SilentlyContinue) {
    $pendingReboot = $true
}

# Check if reboot is pending due to file operations
if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -ErrorAction SilentlyContinue) {
    $pendingReboot = $true
}

# Display system information
Write-Host "`nSystem Information:" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green
Write-Host "Computer Name: $env:COMPUTERNAME" -ForegroundColor White
Write-Host "User Name: $env:USERNAME" -ForegroundColor White
Write-Host "Windows Version: $((Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").ProductName)" -ForegroundColor White
Write-Host "PowerShell Version: $($PSVersionTable.PSVersion)" -ForegroundColor White

# Create a setup summary log
$logPath = "$env:USERPROFILE\Desktop\laptop-setup-summary.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$summaryContent = @"
Laptop Setup Summary
====================
Setup completed: $timestamp
Computer: $env:COMPUTERNAME
User: $env:USERNAME

Installed Components:
- Chocolatey package manager
- Custom PowerShell profile with development aliases
- Windows development features enabled
- SSH keys and Git configuration
- Development environment paths and variables

Next Steps:
1. Restart your computer to complete all installations
2. Open a new PowerShell window to test your profile
3. Configure your IDE/editor preferences
4. Clone your repositories to the configured repositories folder
5. Install any project-specific dependencies

Useful Commands:
- 'repos' - Navigate to your repositories folder
- 'sln' - Open solution files in current directory
- 'open' - Open current directory in File Explorer
- 'tree' - Display directory tree structure

Support:
- PowerShell profile location: $PROFILE
- Setup files location: $(Split-Path $PSScriptRoot -Parent)
- Log file: $logPath
"@

$summaryContent | Out-File -FilePath $logPath -Encoding UTF8

# Final recommendations
Write-Host "`nSetup Complete! [SUCCESS]" -ForegroundColor Green
Write-Host "=================" -ForegroundColor Green

if ($pendingReboot) {
    Write-Host "[WARNING] RESTART REQUIRED" -ForegroundColor Red
    Write-Host "A restart is required to complete some installations." -ForegroundColor Yellow
    Write-Host "Please restart your computer when convenient." -ForegroundColor Yellow
}

Write-Host "`nNext Steps:" -ForegroundColor Cyan
Write-Host "1. [RESTART] Restart your computer (if indicated above)" -ForegroundColor White
Write-Host "2. [CHECK] Check your desktop for a setup summary file" -ForegroundColor White
Write-Host "3. [TEST] Open a new PowerShell window to test your profile" -ForegroundColor White
Write-Host "4. [CONFIGURE] Configure your development tools and IDEs" -ForegroundColor White
Write-Host "5. [CLONE] Clone your repositories to your configured repos folder" -ForegroundColor White

Write-Host "`nUseful Resources:" -ForegroundColor Cyan
Write-Host "- Setup summary: $logPath" -ForegroundColor Gray
Write-Host "- PowerShell profile: $PROFILE" -ForegroundColor Gray
Write-Host "- Type 'repos' to navigate to your repositories folder" -ForegroundColor Gray

Write-Host "`nHappy coding! [COMPLETE]" -ForegroundColor Green