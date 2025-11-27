# PowerShell Profile Setup Script
# Sets up PowerShell profile with custom configurations

function Get-UserInput {
    param(
        [string]$Prompt,
        [string]$DefaultValue = "",
        [switch]$IsPath
    )
    
    if ($DefaultValue) {
        $fullPrompt = "$Prompt (default: $DefaultValue): "
    } else {
        $fullPrompt = "$Prompt : "
    }
    
    do {
        $input = Read-Host $fullPrompt
        if ([string]::IsNullOrWhiteSpace($input) -and $DefaultValue) {
            $input = $DefaultValue
        }
        
        if ($IsPath -and $input) {
            # Validate and create path if needed
            try {
                $expandedPath = [Environment]::ExpandEnvironmentVariables($input)
                if (!(Test-Path $expandedPath)) {
                    $create = Read-Host "Path '$expandedPath' doesn't exist. Create it? (y/n)"
                    if ($create -eq 'y' -or $create -eq 'yes') {
                        New-Item -Path $expandedPath -ItemType Directory -Force | Out-Null
                        Write-Host "  + Created directory: $expandedPath" -ForegroundColor Green
                    } else {
                        Write-Host "  ! Please provide a valid path" -ForegroundColor Yellow
                        continue
                    }
                }
                return $expandedPath
            } catch {
                Write-Host "  ! Invalid path format" -ForegroundColor Red
                continue
            }
        }
        
        if (![string]::IsNullOrWhiteSpace($input)) {
            return $input
        }
        
        if (!$DefaultValue) {
            Write-Host "  ! This field is required" -ForegroundColor Yellow
        }
    } while ($true)
}

function Set-PowerShellProfile {
    Write-Host "PowerShell Profile Configuration" -ForegroundColor Cyan
    Write-Host "This will set up your PowerShell profile with useful aliases and functions." -ForegroundColor Yellow
    Write-Host ""

    # Get user preferences
    Write-Host "Configuration Questions:" -ForegroundColor Green
    Write-Host "Please provide the following information:" -ForegroundColor Gray
    Write-Host ""

    # Root repository path (where this setup repo lives)
    $rootRepo = Get-UserInput -Prompt "Root repository path (where this laptop-setup repo is located)" -DefaultValue "C:\Users\$env:USERNAME\Documents\Repos\laptop-setup" -IsPath

    # General repositories path
    $reposPath = Get-UserInput -Prompt "General repositories folder (where you clone other repos)" -DefaultValue "C:\Users\$env:USERNAME\Documents\Repos" -IsPath

    # Scripts path
    $scriptsPath = Get-UserInput -Prompt "Personal scripts folder (for your custom scripts)" -DefaultValue "C:\Users\$env:USERNAME\Documents\Scripts" -IsPath

    Write-Host ""
    Write-Host "Creating PowerShell profile..." -ForegroundColor Yellow

    # Read the template
    $templatePath = Join-Path $PSScriptRoot "powershell-profile-template.ps1"
    if (!(Test-Path $templatePath)) {
        throw "Template file not found: $templatePath"
    }

    $templateContent = Get-Content $templatePath -Raw

    # Replace placeholders
    $profileContent = $templateContent -replace '\{\{ROOTREPO\}\}', $rootRepo
    $profileContent = $profileContent -replace '\{\{REPOSPATH\}\}', $reposPath
    $profileContent = $profileContent -replace '\{\{SCRIPTPATH\}\}', $scriptsPath

    # Ensure PowerShell profile directory exists
    $profileDir = Split-Path $PROFILE -Parent
    if (!(Test-Path $profileDir)) {
        New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
    }

    # Write the profile
    try {
        $profileContent | Out-File -FilePath $PROFILE -Encoding UTF8 -Force
        Write-Host "  + PowerShell profile created: $PROFILE" -ForegroundColor Green
        
        # Show what was configured
        Write-Host ""
        Write-Host "Profile Configuration Summary:" -ForegroundColor Cyan
        Write-Host "  + Root repository: $rootRepo" -ForegroundColor Gray
        Write-Host "  + Repositories folder: $reposPath" -ForegroundColor Gray
        Write-Host "  + Scripts folder: $scriptsPath" -ForegroundColor Gray
        Write-Host ""
        Write-Host "Available aliases and functions:" -ForegroundColor Green
        Write-Host "  + 'repos' - Navigate to repositories folder" -ForegroundColor Gray
        Write-Host "  + 'scripts' - Navigate to scripts folder" -ForegroundColor Gray
        Write-Host "  + 'root' - Navigate to root repository" -ForegroundColor Gray
        Write-Host "  + 'll' - Enhanced directory listing" -ForegroundColor Gray
        Write-Host "  + 'grep' - Search text in files" -ForegroundColor Gray
        Write-Host "  + 'touch' - Create new files" -ForegroundColor Gray
        Write-Host "  + 'which' - Find command location" -ForegroundColor Gray
        Write-Host "  + Git aliases and Oh-My-Posh integration" -ForegroundColor Gray
        Write-Host "  + Chocolatey tab completion" -ForegroundColor Gray
        
    } catch {
        Write-Host "  ! Error creating PowerShell profile: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# Main execution
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "      PowerShell Profile Setup         " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

try {
    Set-PowerShellProfile
    Write-Host ""
    Write-Host "PowerShell profile setup completed!" -ForegroundColor Green
    Write-Host "Restart PowerShell or run '. `$PROFILE' to load the new profile" -ForegroundColor Yellow
} catch {
    Write-Host "PowerShell profile setup failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}