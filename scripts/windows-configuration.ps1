# Windows Configuration Script
# Configures Windows features and settings for development

function Enable-WindowsFeatures {
    Write-Host "Configuring Windows features..." -ForegroundColor Yellow

    # Windows features that are useful for development
    $features = @(
        "Microsoft-Windows-Subsystem-Linux",
        "VirtualMachinePlatform",
        "Containers-DisposableClientVM",
        "Microsoft-Hyper-V-All",
        "IIS-WebServerRole",
        "IIS-WebServer",
        "IIS-CommonHttpFeatures",
        "IIS-HttpErrors",
        "IIS-HttpRedirect",
        "IIS-ApplicationDevelopment",
        "IIS-NetFxExtensibility45",
        "IIS-HealthAndDiagnostics",
        "IIS-HttpLogging",
        "IIS-Security",
        "IIS-RequestFiltering",
        "IIS-Performance",
        "IIS-WebServerManagementTools",
        "IIS-ManagementConsole",
        "IIS-IIS6ManagementCompatibility",
        "IIS-Metabase",
        "TelnetClient"
    )

    foreach ($feature in $features) {
        try {
            $result = Get-WindowsOptionalFeature -Online -FeatureName $feature -ErrorAction SilentlyContinue
            if ($result -and $result.State -ne "Enabled") {
                Write-Host "  + Enabling $feature..." -ForegroundColor Green
                Enable-WindowsOptionalFeature -Online -FeatureName $feature -All -NoRestart -ErrorAction SilentlyContinue | Out-Null
            }
            elseif ($result) {
                Write-Host "  * $feature already enabled" -ForegroundColor Gray
            }
            else {
                Write-Host "  - $feature not available on this system" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "  ! Error enabling $feature : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

function Set-DeveloperSettings {
    Write-Host "Configuring Windows developer settings..." -ForegroundColor Yellow

    # Enable Developer Mode
    try {
        $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
        if (!(Test-Path $registryPath)) {
            New-Item -Path $registryPath -Force | Out-Null
        }
        Set-ItemProperty -Path $registryPath -Name "AllowDevelopmentWithoutDevLicense" -Value 1 -Force
        Write-Host "  + Developer mode enabled" -ForegroundColor Green
    }
    catch {
        Write-Host "  ! Error enabling developer mode: $($_.Exception.Message)" -ForegroundColor Red
    }

    # Show file extensions
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Force
        Write-Host "  + File extensions will be shown" -ForegroundColor Green
    }
    catch {
        Write-Host "  ! Error setting file extension visibility: $($_.Exception.Message)" -ForegroundColor Red
    }

    # Show hidden files
    try {
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1 -Force
        Write-Host "  + Hidden files will be shown" -ForegroundColor Green
    }
    catch {
        Write-Host "  ! Error setting hidden file visibility: $($_.Exception.Message)" -ForegroundColor Red
    }

    # Enable long path support
    try {
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -Value 1 -Force
        Write-Host "  + Long path support enabled" -ForegroundColor Green
    }
    catch {
        Write-Host "  ! Error enabling long path support: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Main execution
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "          Windows Configuration Setup          " -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

Enable-WindowsFeatures
Set-DeveloperSettings

Write-Host "Windows configuration completed" -ForegroundColor Green
Write-Host "Note: Some changes may require a restart to take effect" -ForegroundColor Yellow