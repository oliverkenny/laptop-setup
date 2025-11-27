# Laptop Setup Script

This modular PowerShell setup automates the installation of essential developer tools and system configurations on a Windows machine.

---

## 📁 Project Structure

```
├── setup.ps1                         # Main orchestration script
├── scripts/
│   ├── installation.ps1             # System-level installations (Chocolatey)
│   ├── windows-configuration.ps1    # Windows features and settings
│   ├── powershell-profile-setup.ps1 # Interactive PowerShell profile configuration
│   ├── powershell-profile-template.ps1 # PowerShell profile template
│   ├── dev-environment-setup.ps1    # Development paths and environment
│   ├── chocolatey-packages.ps1      # Interactive package selection
│   ├── ssh-git-setup.ps1           # SSH keys and Git configuration
│   └── final-setup.ps1             # Cleanup and next steps
└── README.md
```

---

## ✅ What This Script Does

### System Setup (`installation.ps1`)
- Installs Chocolatey package manager
- Configures execution policies and security settings
- Sets up system-level requirements

### Windows Configuration (`windows-configuration.ps1`)
- **Enables Windows Features**: WSL2, Hyper-V, IIS, Containers
- **Developer Settings**: Show file extensions, hidden files, dark mode
- **Performance Tweaks**: Disable startup delays, Cortana, Bing search
- **Security Settings**: Configure Windows Defender exclusions

### PowerShell Configuration (`powershell-profile-setup.ps1`)
- **Interactive setup** with Q&A for directory paths:
  - Root repository directory (startup location)
  - Repositories folder (for Git repos)
  - Scripts directory (for custom PowerShell scripts)
- Creates directories if they don't exist
- Generates custom PowerShell profile with aliases and functions
- Configures Oh-My-Posh theme integration
- Sets appropriate execution policies

### Development Environment (`dev-environment-setup.ps1`)
- **PATH Configuration**: Adds common development tool paths
- **Directory Structure**: Creates standard development folders
- **Environment Variables**: Sets EDITOR, BROWSER, TERM
- **Tool Configuration**: npm, pip default settings
- **Common Directories**: ~/source, ~/projects, ~/scripts, ~/tools

### Package Installation (`chocolatey-packages.ps1`)
- **Interactive selection** of 80+ development tools:
  - **Browsers:** Chrome, Firefox, Edge
  - **IDEs:** VS Code, Visual Studio, JetBrains Suite, PyCharm
  - **Version Control:** Git, GitHub Desktop, Sourcetree, TortoiseGit
  - **Terminals:** Windows Terminal, PowerShell Core, Cmder
  - **Languages:** Node.js, Python, .NET, Java, Go, Rust
  - **Databases:** SQL Server, PostgreSQL, MySQL, MongoDB tools
  - **DevOps:** Docker, Kubernetes, Terraform, AWS/Azure CLIs
  - **APIs:** Postman, Insomnia, Fiddler
  - **Utilities:** 7-Zip, Everything search, Sysinternals
  - **Communication:** Slack, Discord, Teams, Zoom

### SSH & Git Setup (`ssh-git-setup.ps1`)
- **Git Configuration**: Username, email, default settings
- **SSH Key Generation**: Creates RSA keys for GitHub/GitLab
- **SSH Agent Setup**: Configures SSH agent service
- **Public Key Display**: Shows key for easy copying to Git services

### Final Setup (`final-setup.ps1`)
- **Environment Refresh**: Updates PATH and variables
- **Reboot Detection**: Checks for pending Windows restarts
- **Setup Summary**: Creates desktop summary log
- **Next Steps Guide**: Provides clear post-setup instructions

---

## 🚀 Usage Options

### **Quick Setup (Recommended)**
Download and run the complete setup with interactive configuration:

```powershell
# Download the repository as a ZIP file
Invoke-WebRequest -Uri "https://github.com/oliverkenny/laptop-setup/archive/refs/heads/main.zip" -OutFile "laptop-setup.zip"

# Extract the ZIP file
Expand-Archive -Path "laptop-setup.zip" -DestinationPath "." -Force

# Navigate to the extracted folder
cd laptop-setup-main

# Run as Administrator (recommended for full functionality)
.\setup.ps1
```

### **Customized Setup Options**
Control what gets installed:

```powershell
# Skip software packages (system setup only)
.\setup.ps1 -SkipPackages

# Skip Windows configuration (useful for non-admin users)
.\setup.ps1 -SkipWindowsConfig

# Skip Git/SSH setup (if you prefer manual configuration)
.\setup.ps1 -SkipGitConfig

# Minimal setup (system and profile only)
.\setup.ps1 -SkipPackages -SkipWindowsConfig -SkipGitConfig
```

### **Install All Packages Without Prompting**
For automated deployment:

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