# Chocolatey package installation with user selection
param(
    [switch]$InstallAll
)

Write-Host "=== Chocolatey Package Setup ===" -ForegroundColor Cyan

# List of available packages with descriptions (based on your original list)
$packages = @(
    # Browsers
    @{ Name = "googlechrome"; Description = "Google Chrome browser" },
    @{ Name = "firefox"; Description = "Mozilla Firefox browser" },
    @{ Name = "microsoft-edge"; Description = "Microsoft Edge browser" },
    
    # Editors & IDEs
    @{ Name = "vscode"; Description = "Visual Studio Code editor" },
    @{ Name = "visualstudio2022professional"; Description = "Visual Studio 2022 Professional" },
    @{ Name = "notepadplusplus"; Description = "Notepad++ text editor" },
    @{ Name = "jetbrains-rider"; Description = "JetBrains Rider .NET IDE" },
    @{ Name = "intellijidea-community"; Description = "IntelliJ IDEA Community Edition" },
    @{ Name = "pycharm-community"; Description = "PyCharm Community Edition Python IDE" },
    
    # Version Control & Dev Tools
    @{ Name = "git"; Description = "Git version control system" },
    @{ Name = "github-desktop"; Description = "GitHub Desktop GUI for Git" },
    @{ Name = "sourcetree"; Description = "Sourcetree Git GUI client" },
    @{ Name = "tortoisegit"; Description = "TortoiseGit Windows shell integration" },
    
    # Terminal & Shell
    @{ Name = "oh-my-posh"; Description = "Oh My Posh prompt theme engine" },
    @{ Name = "conemu"; Description = "ConEmu terminal emulator" },
    @{ Name = "windows-terminal"; Description = "Windows Terminal (modern terminal)" },
    @{ Name = "powershell-core"; Description = "PowerShell 7+ cross-platform" },
    @{ Name = "cmder"; Description = "Cmder portable console emulator" },
    
    # Runtime & Languages
    @{ Name = "nodejs"; Description = "Node.js JavaScript runtime" },
    @{ Name = "nvm.install"; Description = "Node Version Manager for Windows" },
    @{ Name = "python"; Description = "Python programming language" },
    @{ Name = "dotnet"; Description = ".NET runtime and SDK" },
    @{ Name = "openjdk"; Description = "OpenJDK Java Development Kit" },
    @{ Name = "golang"; Description = "Go programming language" },
    @{ Name = "rust"; Description = "Rust programming language" },
    
    # API & Testing Tools
    @{ Name = "postman"; Description = "Postman API development tool" },
    @{ Name = "insomnia-rest-api-client"; Description = "Insomnia REST API client" },
    @{ Name = "fiddler"; Description = "Fiddler web debugging proxy" },
    @{ Name = "wireshark"; Description = "Wireshark network protocol analyzer" },
    
    # Database Tools
    @{ Name = "sql-server-2022"; Description = "SQL Server 2022" },
    @{ Name = "sql-server-management-studio"; Description = "SQL Server Management Studio" },
    @{ Name = "dbeaver"; Description = "DBeaver universal database tool" },
    @{ Name = "mongodb-compass"; Description = "MongoDB Compass database GUI" },
    @{ Name = "redis-desktop-manager"; Description = "Redis desktop manager" },
    @{ Name = "postgresql"; Description = "PostgreSQL database server" },
    @{ Name = "mysql"; Description = "MySQL database server" },
    
    # Containers & DevOps
    @{ Name = "docker-desktop"; Description = "Docker Desktop" },
    @{ Name = "kubernetes-cli"; Description = "Kubernetes command-line tool (kubectl)" },
    @{ Name = "terraform"; Description = "Terraform infrastructure as code" },
    @{ Name = "vagrant"; Description = "Vagrant virtual machine manager" },
    @{ Name = "virtualbox"; Description = "VirtualBox virtualization platform" },
    
    # Cloud Tools
    @{ Name = "aws-cli"; Description = "AWS Command Line Interface" },
    @{ Name = "azure-cli"; Description = "Azure Command Line Interface" },
    @{ Name = "gcloudsdk"; Description = "Google Cloud SDK" },
    
    # File Management & Utilities
    @{ Name = "7zip"; Description = "7-Zip file archiver" },
    @{ Name = "winrar"; Description = "WinRAR file archiver" },
    @{ Name = "everything"; Description = "Everything file search tool" },
    @{ Name = "treesizefree"; Description = "TreeSize disk space analyzer" },
    @{ Name = "windirstat"; Description = "WinDirStat disk usage analyzer" },
    
    # Communication & Productivity
    @{ Name = "slack"; Description = "Slack team communication" },
    @{ Name = "discord"; Description = "Discord voice and text chat" },
    @{ Name = "microsoft-teams"; Description = "Microsoft Teams collaboration" },
    @{ Name = "zoom"; Description = "Zoom video conferencing" },
    @{ Name = "notion"; Description = "Notion workspace and notes" },
    @{ Name = "obsidian"; Description = "Obsidian knowledge management" },
    
    # Media & Design
    @{ Name = "vlc"; Description = "VLC media player" },
    @{ Name = "gimp"; Description = "GIMP image editor" },
    @{ Name = "inkscape"; Description = "Inkscape vector graphics editor" },
    @{ Name = "blender"; Description = "Blender 3D modeling and animation" },
    @{ Name = "figma"; Description = "Figma design and prototyping" },
    
    # Security & System
    @{ Name = "bitwarden"; Description = "Bitwarden password manager" },
    @{ Name = "keepass"; Description = "KeePass password manager" },
    @{ Name = "sysinternals"; Description = "Microsoft Sysinternals utilities" },
    @{ Name = "procexp"; Description = "Process Explorer system monitor" },
    @{ Name = "autoruns"; Description = "Autoruns startup programs manager" },
    
    # Package Managers & Build Tools
    @{ Name = "yarn"; Description = "Yarn package manager for Node.js" },
    @{ Name = "maven"; Description = "Apache Maven build automation" },
    @{ Name = "gradle"; Description = "Gradle build automation tool" },
    @{ Name = "make"; Description = "GNU Make build automation" },
    @{ Name = "cmake"; Description = "CMake build system generator" },
    
    # Text Processing & Documentation
    @{ Name = "pandoc"; Description = "Pandoc document converter" },
    @{ Name = "marktext"; Description = "MarkText markdown editor" },
    @{ Name = "typora"; Description = "Typora markdown editor" },
    @{ Name = "calibre"; Description = "Calibre ebook management" }
)

# Check if Chocolatey is installed (should be installed by installation.ps1)
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey not found. Please run the installation script first." -ForegroundColor Red
    exit 1
}

if ($InstallAll) {
    Write-Host "Installing all packages..." -ForegroundColor Green
    $packagesToInstall = $packages.Name
} else {
    # Interactive package selection
    Write-Host "`nAvailable Chocolatey packages:" -ForegroundColor Cyan
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "Select packages to install (y/N for each):`n" -ForegroundColor Yellow
    
    $selectedPackages = @()
    
    foreach ($package in $packages) {
        $choice = Read-Host "Install $($package.Name) - $($package.Description)? (y/N)"
        if ($choice -eq 'y' -or $choice -eq 'Y' -or $choice -eq 'yes') {
            $selectedPackages += $package.Name
            Write-Host "  ✓ Added $($package.Name)" -ForegroundColor Green
        }
    }
    
    $packagesToInstall = $selectedPackages
}

# Install selected packages
if ($packagesToInstall.Count -gt 0) {
    Write-Host "`nInstalling $($packagesToInstall.Count) selected packages..." -ForegroundColor Green
    Write-Host "================================" -ForegroundColor Cyan
    Write-Host "Installing quietly... Only errors will be shown.`n" -ForegroundColor Yellow
    
    $totalPackages = $packagesToInstall.Count
    $currentPackage = 0
    $failedPackages = @()
    $successfulPackages = @()
    
    foreach ($package in $packagesToInstall) {
        $currentPackage++
        Write-Progress -Activity "Installing Chocolatey Packages" -Status "Installing $package ($currentPackage of $totalPackages)" -PercentComplete (($currentPackage / $totalPackages) * 100)
        
        try {
            # Install quietly with minimal output
            $output = choco install $package -y --ignore-checksums --timeout=600 --no-progress 2>&1
            $exitCode = $LASTEXITCODE
            
            if ($exitCode -eq 0) {
                $successfulPackages += $package
            } else {
                $failedPackages += @{ Package = $package; Error = "Installation failed with exit code $exitCode" }
                Write-Host "  ✗ Failed to install $package (exit code: $exitCode)" -ForegroundColor Red
            }
        } catch {
            $failedPackages += @{ Package = $package; Error = $_.Exception.Message }
            Write-Host "  ✗ Failed to install $package : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    # Clear the progress bar
    Write-Progress -Activity "Installing Chocolatey Packages" -Completed
    
    # Summary report
    Write-Host "`n================================" -ForegroundColor Cyan
    Write-Host "Installation Summary:" -ForegroundColor Green
    Write-Host "  ✓ Successfully installed: $($successfulPackages.Count) packages" -ForegroundColor Green
    
    if ($successfulPackages.Count -gt 0) {
        Write-Host "    Installed packages: $($successfulPackages -join ', ')" -ForegroundColor Gray
    }
    
    if ($failedPackages.Count -gt 0) {
        Write-Host "  ✗ Failed installations: $($failedPackages.Count) packages" -ForegroundColor Red
        foreach ($failed in $failedPackages) {
            Write-Host "    - $($failed.Package): $($failed.Error)" -ForegroundColor Red
        }
    }
    
    Write-Host "`nPackage installation complete!" -ForegroundColor Green
} else {
    Write-Host "No packages selected for installation." -ForegroundColor Yellow
}