# SSH and Git Configuration Script
# --------------------------------
# This script sets up SSH keys and Git configuration

Write-Host "=== SSH and Git Configuration ===" -ForegroundColor Cyan

# Git Configuration
Write-Host "Configuring Git..." -ForegroundColor Yellow

$gitUserName = Read-Host "Enter your Git username (or press Enter to skip)"
if ($gitUserName) {
    git config --global user.name "$gitUserName"
    Write-Host "  ✓ Git username set to: $gitUserName" -ForegroundColor Green
}

$gitUserEmail = Read-Host "Enter your Git email (or press Enter to skip)"
if ($gitUserEmail) {
    git config --global user.email "$gitUserEmail"
    Write-Host "  ✓ Git email set to: $gitUserEmail" -ForegroundColor Green
}

# Set useful Git defaults
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf true
git config --global core.editor "code --wait"

Write-Host "  ✓ Git defaults configured" -ForegroundColor Green

# SSH Key Generation
Write-Host "`nSSH Key Setup..." -ForegroundColor Yellow
$sshDir = "$env:USERPROFILE\.ssh"

if (-not (Test-Path $sshDir)) {
    New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
}

$sshKeyPath = "$sshDir\id_rsa"
if (-not (Test-Path $sshKeyPath)) {
    $generateKey = Read-Host "Generate SSH key for Git/GitHub? (y/N)"
    if ($generateKey -eq 'y' -or $generateKey -eq 'Y' -or $generateKey -eq 'yes') {
        $keyEmail = if ($gitUserEmail) { $gitUserEmail } else { Read-Host "Enter email for SSH key" }
        if ($keyEmail) {
            ssh-keygen -t rsa -b 4096 -C "$keyEmail" -f "$sshKeyPath" -N '""'
            Write-Host "  ✓ SSH key generated at: $sshKeyPath" -ForegroundColor Green
            
            # Start SSH agent and add key
            Start-Service ssh-agent
            ssh-add "$sshKeyPath"
            
            # Display public key for copying
            Write-Host "`nYour SSH public key (copy this to GitHub/GitLab):" -ForegroundColor Cyan
            Write-Host "===========================================" -ForegroundColor Cyan
            Get-Content "$sshKeyPath.pub"
            Write-Host "===========================================" -ForegroundColor Cyan
            Write-Host "You can also copy it later with: Get-Content `"$sshKeyPath.pub`" | Set-Clipboard" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "  ✓ SSH key already exists at: $sshKeyPath" -ForegroundColor Green
}

Write-Host "`n✓ SSH and Git configuration completed" -ForegroundColor Green