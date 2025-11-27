# Main setup script that orchestrates the installation process
param(
    [switch]$SkipPackages,
    [switch]$SkipWindowsConfig,
    [switch]$SkipGitConfig
)

Write-Host "=== Development Environment Setup Script ===" -ForegroundColor Green
Write-Host "Comprehensive Windows development environment setup" -ForegroundColor Gray
Write-Host ""

# Check if running as Administrator for some operations
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "⚠️  Some features require Administrator privileges" -ForegroundColor Yellow
    Write-Host "Consider running as Administrator for full functionality" -ForegroundColor Yellow
    Write-Host ""
}

# 1. Core system setup
Write-Host "Step 1: Core system setup..." -ForegroundColor Yellow
& ".\scripts\installation.ps1"

# 2. Windows configuration (if not skipped and admin)
if (-not $SkipWindowsConfig -and $isAdmin) {
    Write-Host "`nStep 2: Windows configuration..." -ForegroundColor Yellow
    & ".\scripts\windows-configuration.ps1"
} elseif (-not $isAdmin) {
    Write-Host "`nStep 2: Skipping Windows configuration (requires admin)" -ForegroundColor Yellow
} else {
    Write-Host "`nStep 2: Skipping Windows configuration (user requested)" -ForegroundColor Yellow
}

# 3. PowerShell profile setup
Write-Host "`nStep 3: PowerShell profile setup..." -ForegroundColor Yellow
& ".\scripts\powershell-profile-setup.ps1"

# 4. Development environment setup
Write-Host "`nStep 4: Development environment setup..." -ForegroundColor Yellow
& ".\scripts\dev-environment-setup.ps1"

# 5. Package installation (if not skipped)
if (-not $SkipPackages) {
    Write-Host "`nStep 5: Software package installation..." -ForegroundColor Yellow
    & ".\scripts\chocolatey-packages.ps1"
} else {
    Write-Host "`nStep 5: Skipping package installation (user requested)" -ForegroundColor Yellow
}

# 6. SSH and Git configuration (if not skipped)
if (-not $SkipGitConfig) {
    Write-Host "`nStep 6: SSH and Git configuration..." -ForegroundColor Yellow
    & ".\scripts\ssh-git-setup.ps1"
} else {
    Write-Host "`nStep 6: Skipping SSH/Git configuration (user requested)" -ForegroundColor Yellow
}

# 7. Final setup and next steps
Write-Host "`nStep 7: Final setup tasks..." -ForegroundColor Yellow
& ".\scripts\final-setup.ps1"