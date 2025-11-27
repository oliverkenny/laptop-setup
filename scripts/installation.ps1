
# System Installation Script
# --------------------------
# This script handles system-level installations and configurations.
# Package installations are now handled by chocolatey-packages.ps1

Write-Host "Starting system installation..." -ForegroundColor Cyan

# Ensure execution policy and TLS settings
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# Install Chocolatey if not already installed
if (!(Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..." -ForegroundColor Yellow
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Host "Chocolatey installed successfully." -ForegroundColor Green
} else {
    Write-Host "Chocolatey is already installed." -ForegroundColor Green
}

# Add any other system-level configurations here
# For example: Windows features, registry settings, etc.

Write-Host "System installation completed." -ForegroundColor Green

# Optional: Configure NVM after install
if (Get-Command nvm -ErrorAction SilentlyContinue) {
    Write-Host "Configuring NVM..."
    nvm install latest
    nvm use latest
}
