
# Laptop Setup Script using Chocolatey
# -------------------------------------
# This script installs common developer tools and handles errors gracefully.
# Run as Administrator.

# Ensure execution policy and TLS settings
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

# Install Chocolatey if not already installed
if (!(Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed."
}

# Define packages
$packages = @(
    # Browsers
    "googlechrome",

    # Editors & IDEs
    "vscode",
    "visualstudio2022professional",
    "notepadplusplus",

    # Dev Tools
    "git",
    "nvm.install",
    "oh-my-posh",
    "postman",
    "conemu",

    # Database
    "sql-server-2022"
)

# Install packages
foreach ($pkg in $packages) {
    Write-Host "Installing $pkg..."
    try {
        choco install $pkg -y --ignore-checksums --timeout=600
        Write-Host "$pkg installed successfully."
    } catch {
        Write-Host "Failed to install ${pkg}: $_"
    }
}

# Optional: Configure NVM after install
if (Get-Command nvm -ErrorAction SilentlyContinue) {
    Write-Host "Configuring NVM..."
    nvm install latest
    nvm use latest
}

