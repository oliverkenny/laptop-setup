
# Laptop Setup Script

This PowerShell script automates the installation of essential developer tools on a Windows machine using [Chocolatey](https://chocolatey.orgript Does
- Installs common development tools:
  - Visual Studio 2022
  - VS Code
  - Git
  - SQL Server 2022
  - Google Chrome
  - Postman
  - Notepad++
  - NVM (Node Version Manager)
  - Oh-My-Posh
  - ConEmu
- Configures Chocolatey if not already installed.

---

## 🚀 Quick Start

### **Run Directly from PowerShell**
Open **PowerShell as Administrator** and run:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/oliverkenny/laptop-setup/refs/heads/main/setup.ps1'))
