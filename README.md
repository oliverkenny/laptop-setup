# Laptop Setup Script

This modular PowerShell setup automates the installation of essential developer tools and system configurations on a Windows machine.

---

## 📁 Project Structure

```
├── setup.ps1                         # Main orchestration script
├── scripts/
│   ├── installation.ps1             # System-level installations (Chocolatey)
│   ├── powershell-profile-setup.ps1 # Interactive PowerShell profile configuration
│   ├── powershell-profile-template.ps1 # PowerShell profile template
│   └── chocolatey-packages.ps1      # Interactive package selection
└── README.md
```

---

## ✅ What This Script Does

### System Setup (`installation.ps1`)
- Installs Chocolatey package manager
- Configures execution policies and security settings
- Sets up system-level requirements

### PowerShell Configuration (`powershell-profile-setup.ps1`)
- **Interactive setup** with Q&A for directory paths:
  - Root repository directory (startup location)
  - Repositories folder (for Git repos)
  - Scripts directory (for custom PowerShell scripts)
- Creates directories if they don't exist
- Generates custom PowerShell profile with aliases and functions
- Configures Oh-My-Posh theme integration
- Sets appropriate execution policies

### Package Installation (`chocolatey-packages.ps1`)
- Interactive selection of development tools:
  - **Browsers:** Google Chrome
  - **Editors & IDEs:** VS Code, Visual Studio 2022 Professional, Notepad++
  - **Dev Tools:** Git, NVM, Oh-My-Posh, Postman, ConEmu
  - **Database:** SQL Server 2022, SQL Server Management Studio
  - **Utilities:** 7-Zip, VLC, Docker Desktop, Slack
  - **Runtime:** Node.js, Python

---

## 🚀 Usage Options

### **Quick Setup (Recommended)**
Download and run the complete setup with interactive package selection:

```powershell
# Download the repository as a ZIP file
Invoke-WebRequest -Uri "https://github.com/oliverkenny/laptop-setup/archive/refs/heads/main.zip" -OutFile "laptop-setup.zip"

# Extract the ZIP file
Expand-Archive -Path "laptop-setup.zip" -DestinationPath "." -Force

# Navigate to the extracted folder
cd laptop-setup-main

# Run as Administrator
.\setup.ps1
```

**Alternative: Direct execution without download**
```powershell
# Run directly from GitHub (requires internet connection)
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/oliverkenny/laptop-setup/main/setup.ps1'))
```

### **Skip Package Installation**
Run only system setup and PowerShell profile configuration:

```powershell
.\setup.ps1 -SkipPackages
```

### **Install All Packages Without Prompting**
Install all available packages automatically:

```powershell
.\scripts\chocolatey-packages.ps1 -InstallAll
```

### **Run Individual Scripts**
Execute specific components:

```powershell
# System setup only
.\scripts\installation.ps1

# Package installation only
.\scripts\chocolatey-packages.ps1

# PowerShell profile setup only
.\scripts\powershell-profile-setup.ps1
```

---

## ⚠️ Requirements

- Windows 10/11
- Administrator privileges
- Internet connection

---

## 🔧 Customization

To modify the available packages:
1. Edit `scripts\chocolatey-packages.ps1`
2. Add or remove packages from the `$packages` array
3. Include package name and description

To add new setup steps:
1. Create new script in `scripts\` folder
2. Add execution call to `setup.ps1`

---

## 🔒 Security Notes

- All scripts are hosted on GitHub using HTTPS
- Interactive package selection prevents unwanted installations
- Modular design allows running only needed components
- Review scripts before execution for security verification