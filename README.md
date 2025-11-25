
# Laptop Setup Script

This PowerShell script automates the installation of essential developer tools on a Windows machine using Chocolatey.

---

## ✅ What This Script Does
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

## 🚀 How to Run the Script

You have **two options**:

---

### **Option 1: Run Directly from GitHub (Quick Method)**
> ⚠️ This method may be blocked by antivirus because it uses `Invoke-Expression`. If that happens, use Option 2.

Open **PowerShell as Administrator** and run:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/oliverkenny/laptop-setup/refs/heads/main/setup.ps1'))
````

---

### **Option 2: Download and Run Locally (Recommended)**

This avoids antivirus warnings and is safer.

1.  **Download the script:**
    ```powershell
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/oliverkenny/laptop-setup/refs/heads/main/setup.ps1" -OutFile "setup.ps1"
    ```

2.  **Run the script with execution policy bypass:**
    ```powershell
    powershell.exe -ExecutionPolicy Bypass -File .\setup.ps1
    ```

---

## ⚠️ Requirements

*   Windows 10/11
*   Administrator privileges
*   Internet connection

---

## 🔒 Security Note

*   The script is hosted on GitHub and uses HTTPS.
*   For extra security, verify the script’s integrity before running:
    ```powershell
    Get-FileHash .\setup.ps1 -Algorithm SHA256
    ```
    Compare the hash with the one published in this README (add your hash here after generating it).

---

## 🛠 Customization

To add or remove packages:

*   Edit `setup.ps1` and modify the `choco install` lines.
*   Commit changes to your GitHub repo.
