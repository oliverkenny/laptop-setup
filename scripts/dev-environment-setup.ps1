# Development Environment Setup Script
# Configures PATH, environment variables, and development directories

function Add-ToPath {
    param([string[]]$Paths)
    
    Write-Host "Configuring system PATH..." -ForegroundColor Yellow
    
    $currentPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::User)
    $pathsToAdd = @()
    
    # Common development paths to add
    $devPaths = @(
        "${env:USERPROFILE}\.dotnet\tools",
        "${env:USERPROFILE}\AppData\Local\Programs\Microsoft VS Code\bin",
        "${env:USERPROFILE}\AppData\Roaming\npm",
        "${env:PROGRAMFILES}\Git\cmd",
        "${env:PROGRAMFILES}\Docker\Docker\resources\bin",
        "${env:PROGRAMFILES}\dotnet",
        "${env:PROGRAMFILES(X86)}\Microsoft Visual Studio\2019\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TestWindow",
        "${env:PROGRAMFILES(X86)}\Microsoft Visual Studio\2019\Professional\Common7\IDE\CommonExtensions\Microsoft\TestWindow",
        "${env:PROGRAMFILES(X86)}\Microsoft Visual Studio\2022\Enterprise\Common7\IDE\CommonExtensions\Microsoft\TestWindow",
        "${env:PROGRAMFILES(X86)}\Microsoft Visual Studio\2022\Professional\Common7\IDE\CommonExtensions\Microsoft\TestWindow"
    )
    
    # Add custom paths from parameters
    $allPaths = $devPaths + $Paths
    
    foreach ($path in $allPaths) {
        $expandedPath = [Environment]::ExpandEnvironmentVariables($path)
        if (![string]::IsNullOrWhiteSpace($expandedPath) -and (Test-Path $expandedPath) -and ($currentPath -notlike "*$expandedPath*")) {
            $pathsToAdd += $expandedPath
        }
    }
    
    if ($pathsToAdd.Count -gt 0) {
        $newPath = $currentPath + ";" + ($pathsToAdd -join ";")
        [Environment]::SetEnvironmentVariable("PATH", $newPath, [EnvironmentVariableTarget]::User)
        
        foreach ($addedPath in $pathsToAdd) {
            Write-Host "  + Added to PATH: $addedPath" -ForegroundColor Green
        }
    } else {
        Write-Host "  * All development paths are already in PATH" -ForegroundColor Gray
    }
}

function Set-DevelopmentDirectories {
    Write-Host "Creating development directories..." -ForegroundColor Yellow
    
    $directories = @(
        "${env:USERPROFILE}\Documents\Repos",
        "${env:USERPROFILE}\Documents\Scripts",
        "${env:USERPROFILE}\Documents\Projects",
        "${env:USERPROFILE}\.ssh",
        "${env:USERPROFILE}\.aws",
        "${env:USERPROFILE}\.docker",
        "${env:USERPROFILE}\.kube",
        "${env:USERPROFILE}\Desktop\Quick Access"
    )
    
    foreach ($dir in $directories) {
        $expandedDir = [Environment]::ExpandEnvironmentVariables($dir)
        if (!(Test-Path $expandedDir)) {
            try {
                New-Item -Path $expandedDir -ItemType Directory -Force | Out-Null
                Write-Host "  + Created: $expandedDir" -ForegroundColor Green
            } catch {
                Write-Host "  ! Error creating $expandedDir : $($_.Exception.Message)" -ForegroundColor Red
            }
        } else {
            Write-Host "  * Already exists: $expandedDir" -ForegroundColor Gray
        }
    }
}

function Set-EnvironmentVariables {
    Write-Host "Setting development environment variables..." -ForegroundColor Yellow
    
    $envVars = @{
        "DOTNET_CLI_TELEMETRY_OPTOUT" = "1"
        "POWERSHELL_TELEMETRY_OPTOUT" = "1"
        "AZURE_CORE_COLLECT_TELEMETRY" = "0"
        "DO_NOT_TRACK" = "1"
    }
    
    foreach ($var in $envVars.GetEnumerator()) {
        try {
            [Environment]::SetEnvironmentVariable($var.Key, $var.Value, [EnvironmentVariableTarget]::User)
            Write-Host "  + Set $($var.Key) = $($var.Value)" -ForegroundColor Green
        } catch {
            Write-Host "  ! Error setting $($var.Key): $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

function Set-PipConfiguration {
    Write-Host "Configuring pip (Python package manager)..." -ForegroundColor Yellow
    
    $pipConfigDir = "${env:APPDATA}\pip"
    if (!(Test-Path $pipConfigDir)) {
        New-Item -Path $pipConfigDir -ItemType Directory -Force | Out-Null
        Write-Host "  + Created pip config directory" -ForegroundColor Green
    }
    
    $pipConfig = @"
[global]
trusted-host = pypi.org
               pypi.python.org
               files.pythonhosted.org
"@
    
    try {
        $pipConfig | Out-File -FilePath "$pipConfigDir\pip.ini" -Encoding UTF8 -Force
        Write-Host "  + Created pip configuration file" -ForegroundColor Green
    } catch {
        Write-Host "  ! Error creating pip config: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Main execution
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "       Development Environment Setup       " -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

Add-ToPath
Set-DevelopmentDirectories
Set-EnvironmentVariables
Set-PipConfiguration

Write-Host "Development environment setup completed" -ForegroundColor Green