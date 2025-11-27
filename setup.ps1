# Main setup script that orchestrates the installation process
param(
    [switch]$SkipPackages
)

Write-Host "=== Setup Script ===" -ForegroundColor Green

# Execute installation script
Write-Host "Running installation script..." -ForegroundColor Yellow
& ".\scripts\installation.ps1"

# Execute PowerShell profile setup
Write-Host "Setting up PowerShell profile..." -ForegroundColor Yellow
& ".\scripts\powershell-profile-setup.ps1"

# Handle Chocolatey packages unless skipped
if (-not $SkipPackages) {
    Write-Host "Setting up Chocolatey packages..." -ForegroundColor Yellow
    & ".\scripts\chocolatey-packages.ps1"
}

Write-Host "=== Setup Complete! ===" -ForegroundColor Green