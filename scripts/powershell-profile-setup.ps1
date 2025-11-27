# PowerShell Profile Setup Script
# ---------------------------------
# This script sets up a custom PowerShell profile with interactive configuration

Write-Host "=== PowerShell Profile Setup ===" -ForegroundColor Cyan

# Check if profile exists
if (Test-Path $PROFILE) {
    $overwrite = Read-Host "PowerShell profile already exists. Overwrite it? (y/N)"
    if ($overwrite -ne 'y' -and $overwrite -ne 'Y' -and $overwrite -ne 'yes') {
        Write-Host "PowerShell profile setup skipped." -ForegroundColor Yellow
        return
    }
}

# Gather configuration from user
Write-Host "`nConfiguring your development environment:" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

# Root Repository Directory
Write-Host "`n1. Root Repository Directory" -ForegroundColor Yellow
Write-Host "   This is where PowerShell will navigate to on startup."
Write-Host "   Example: C:\Dev, C:\Users\$env:USERNAME\Documents\Projects"
do {
    $rootRepo = Read-Host "   Enter path (or press Enter to skip)"
    if ($rootRepo -and -not (Test-Path $rootRepo)) {
        $create = Read-Host "   Directory doesn't exist. Create it? (y/N)"
        if ($create -eq 'y' -or $create -eq 'Y' -or $create -eq 'yes') {
            try {
                New-Item -Path $rootRepo -ItemType Directory -Force | Out-Null
                Write-Host "   ✓ Directory created." -ForegroundColor Green
                break
            } catch {
                Write-Host "   ✗ Failed to create directory. Please try again." -ForegroundColor Red
            }
        }
    } elseif ($rootRepo) {
        Write-Host "   ✓ Directory exists." -ForegroundColor Green
        break
    } else {
        break
    }
} while ($true)

# Repositories Path
Write-Host "`n2. Repositories Directory" -ForegroundColor Yellow
Write-Host "   Where your Git repositories are stored."
Write-Host "   Example: C:\Repos, C:\Users\$env:USERNAME\source\repos"
do {
    $reposPath = Read-Host "   Enter path (or press Enter to skip)"
    if ($reposPath -and -not (Test-Path $reposPath)) {
        $create = Read-Host "   Directory doesn't exist. Create it? (y/N)"
        if ($create -eq 'y' -or $create -eq 'Y' -or $create -eq 'yes') {
            try {
                New-Item -Path $reposPath -ItemType Directory -Force | Out-Null
                Write-Host "   ✓ Directory created." -ForegroundColor Green
                break
            } catch {
                Write-Host "   ✗ Failed to create directory. Please try again." -ForegroundColor Red
            }
        }
    } elseif ($reposPath) {
        Write-Host "   ✓ Directory exists." -ForegroundColor Green
        break
    } else {
        break
    }
} while ($true)

# Scripts Path
Write-Host "`n3. PowerShell Scripts Directory" -ForegroundColor Yellow
Write-Host "   Where you store your custom PowerShell scripts."
Write-Host "   Example: C:\Scripts, C:\Users\$env:USERNAME\Documents\Scripts"
do {
    $scriptPath = Read-Host "   Enter path (or press Enter to skip)"
    if ($scriptPath -and -not (Test-Path $scriptPath)) {
        $create = Read-Host "   Directory doesn't exist. Create it? (y/N)"
        if ($create -eq 'y' -or $create -eq 'Y' -or $create -eq 'yes') {
            try {
                New-Item -Path $scriptPath -ItemType Directory -Force | Out-Null
                Write-Host "   ✓ Directory created." -ForegroundColor Green
                break
            } catch {
                Write-Host "   ✗ Failed to create directory. Please try again." -ForegroundColor Red
            }
        }
    } elseif ($scriptPath) {
        Write-Host "   ✓ Directory exists." -ForegroundColor Green
        break
    } else {
        break
    }
} while ($true)

Write-Host "`nGenerating PowerShell profile..." -ForegroundColor Green

# Load the profile template
$templatePath = Join-Path $PSScriptRoot "powershell-profile-template.ps1"
if (-not (Test-Path $templatePath)) {
    Write-Host "Error: Profile template not found at $templatePath" -ForegroundColor Red
    return
}

# Read template and replace placeholders
$profileContent = Get-Content $templatePath -Raw
$profileContent = $profileContent.Replace("{{ROOTREPO}}", $rootRepo)
$profileContent = $profileContent.Replace("{{REPOSPATH}}", $reposPath)
$profileContent = $profileContent.Replace("{{SCRIPTPATH}}", $scriptPath)

# Ensure the profile directory exists
$profileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# Write the profile content
$profileContent | Out-File -FilePath $PROFILE -Encoding UTF8

Write-Host "`n✓ PowerShell profile created successfully!" -ForegroundColor Green
Write-Host "Profile location: $PROFILE" -ForegroundColor Cyan

# Set execution policy if needed
try {
    if ((Get-ExecutionPolicy -Scope CurrentUser) -eq 'Restricted') {
        Write-Host "`nSetting execution policy to RemoteSigned for current user..." -ForegroundColor Yellow
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Host "✓ Execution policy updated." -ForegroundColor Green
    }
} catch {
    Write-Host "⚠ Could not update execution policy. You may need to run this as administrator." -ForegroundColor Yellow
}

Write-Host "`nTo activate your new profile, restart PowerShell or run:" -ForegroundColor Cyan
Write-Host ". `$PROFILE" -ForegroundColor White

Write-Host "`nProfile features configured:" -ForegroundColor Green
if ($rootRepo) { Write-Host "  • Startup directory: $rootRepo" }
if ($reposPath) { Write-Host "  • Repositories folder: $reposPath (use 'repos' command)" }
if ($scriptPath) { Write-Host "  • Scripts directory: $scriptPath" }
Write-Host "  • Custom aliases and functions" 
Write-Host "  • Oh-My-Posh theme integration"
Write-Host "  • Chocolatey tab completion"