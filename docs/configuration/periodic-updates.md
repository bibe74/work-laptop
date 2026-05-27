# Periodic Software Updates Guide

## 📋 Overview

This guide provides a comprehensive approach to keeping all software up to date on your Dell XPS 13 9310 (MIRZAKHANI). Regular updates ensure security, stability, and access to the latest features.

**Recommended Schedule**: Monthly (first week of each month)  
**Duration**: 1-2 hours depending on available updates

---

## 🗓️ Update Schedule

### Monthly Updates (First Week)
- Dell firmware and drivers (SupportAssist)
- Windows updates
- Ninite utilities update
- Microsoft Store apps (PowerShell 7, WSL, Teams, WhatsApp, Bitwarden, Power BI Desktop)
- Office 365
- Docker Desktop
- Google Cloud CLI
- SSMS (check for updates)
- Bitwarden
- Cyohash (check SourceForge quarterly)

### Quarterly Updates
- SQL Server 2025 cumulative updates (review release notes)
- Power BI Desktop (standard version - monthly if using desktop app)
- Power BI Report Server (quarterly releases)
- Visual Studio 2019 and 2026 and extensions
- Review and update PowerShell modules
- OpenVPN and FortiClient VPN client updates
- MariaDB updates (check quarterly)

### As Needed
- Garmin Express (updates when device connected)
- Remote Desktop Manager updates
- Font updates (rare)

### As Released
- Critical security patches
- BIOS updates (when security-related)
- VPN client updates (FortiClient)

---

## 🔧 Update Process Order

Follow this sequence for systematic updates:

1. **Dell Firmware & Drivers** (SupportAssist)
2. **Windows Updates**
3. **Microsoft Store Applications**
4. **Ninite Core Utilities**
5. **Development Tools** (manually updated)
6. **Productivity & Communication Tools**
7. **Database & BI Tools**
8. **Cloud Tools**
9. **Docker & WSL**
10. **VPN Clients**

---

## 1️⃣ Dell Firmware & Drivers (SupportAssist)

**Frequency**: Monthly  
**Tool**: Dell SupportAssist for Business PCs  
**Duration**: 15-30 minutes

### Update Steps

1. **Launch SupportAssist**
   - Start Menu → Dell → SupportAssist for Business PCs
   - Or: Click Dell icon in system tray

2. **Run System Check**
   - Click **Check Now** or **Optimize Now**
   - Wait for scan to complete (3-10 minutes)

3. **Review Available Updates**
   
   Updates are categorized as:
   - **BIOS/Firmware**: System BIOS, controller firmware
   - **Drivers**: Chipset, network, graphics, audio, Thunderbolt
   - **Dell Applications**: Dell utilities and tools

4. **Install Driver Updates**
   - Review each driver update
   - Click **Download** or **Install**
   - Most driver updates install without restart
   - Recommended order:
     1. Chipset drivers
     2. Network drivers (WiFi, Ethernet)
     3. Graphics drivers
     4. Audio drivers
     5. Thunderbolt drivers
     6. Other drivers

5. **Install BIOS Updates** (if available)
   
   ⚠️ **Critical BIOS Update Procedure**:
   
   **Before updating BIOS**:
   - [ ] Save all work and close all applications
   - [ ] Connect AC power adapter (REQUIRED)
   - [ ] Ensure battery is charged (>50%)
   - [ ] Disconnect external devices (except mouse/keyboard)
   - [ ] Note current BIOS version for reference
   - [ ] Disable BitLocker if enabled (re-enable after)

   **BIOS Update Steps**:
   ```powershell
   # Check current BIOS version
   Get-ComputerInfo | Select-Object BiosVersion, BiosManufacturer
   ```
   
   - In SupportAssist, click **Install** on BIOS update
   - System will restart to BIOS update mode
   - Progress bar shows update status
   - **DO NOT POWER OFF OR INTERRUPT**
   - System may restart multiple times (5-15 minutes total)
   - After completion, system boots to Windows normally

   **After BIOS Update**:
   - Verify new BIOS version:
     ```powershell
     msinfo32
     # Check BIOS Version/Date
     ```
   - Check all hardware is functioning correctly
   - Re-enable BitLocker if it was disabled

6. **Update Dell Applications**
   - Update Dell Command | Update, Dell Optimizer, etc.
   - Usually quick, no restart required

### Verification

```powershell
# Check BIOS version
Get-ComputerInfo | Select-Object BiosVersion

# Check Dell Command | Update version (if installed)
Get-AppxPackage | Where-Object {$_.Name -like "*Dell*"}
```

### Alternative: Manual Dell Updates

If SupportAssist is unavailable:

1. **Visit Dell Support**
   - Go to: [https://www.dell.com/support/home](https://www.dell.com/support/home)
   - Enter Service Tag or use **Detect Product**

2. **Download Updates**
   - Navigate to **Drivers & Downloads**
   - Select **Windows 11 64-bit**
   - Download needed updates
   - Install manually

---

## 2️⃣ Windows Updates

**Frequency**: Monthly (or as released for security updates)  
**Duration**: 15-60 minutes

### Update Steps

1. **Check for Windows Updates**
   - Settings → Windows Update
   - Click **Check for updates**

2. **Install Available Updates**
   - Download and install all updates
   - May include:
     - Feature updates (major Windows versions)
     - Quality updates (monthly security patches)
     - Driver updates
     - .NET Framework updates

3. **Restart if Required**
   - Some updates require restart
   - Schedule restart during non-work hours if needed

4. **Optional Updates**
   - Click **Advanced options** → **Optional updates**
   - Review optional driver or feature updates
   - Install if needed

5. **Repeat Until No Updates**
   - Run "Check for updates" multiple times
   - Continue until no more updates are available

### Verify Updates

```powershell
# Check Windows version
winver

# Get detailed Windows info
Get-ComputerInfo | Select-Object WindowsVersion, OsVersion, OsBuildNumber

# View update history
Get-HotFix | Sort-Object -Property InstalledOn -Descending | Select-Object -First 10
```

---

## 3️⃣ Microsoft Store Applications

**Frequency**: Monthly or automatic  
**Duration**: 5-15 minutes

### Update Steps

1. **Open Microsoft Store**
   - Start Menu → Microsoft Store

2. **Check for Updates**
   - Click **Library** (bottom left icon)
   - Click **Get updates**

3. **Install Updates**
   - Updates will download and install automatically
   - Applications include:
     - PowerShell 7
     - Windows Terminal
     - Ubuntu (WSL distribution)
     - Any other Store-installed apps

### Configure Automatic Updates

- Microsoft Store → Settings (⚙️ icon)
- Enable **App updates**
- Apps will update automatically in background

---

## 4️⃣ Ninite Core Utilities

**Frequency**: Monthly  
**Duration**: 10-30 minutes

### Update Steps

1. **Locate Saved Ninite Installer**
   - Navigate to where you saved `Ninite_CoreUtilities.exe`
   - Recommended location: `C:\Tools\Ninite\`

2. **Run Ninite**
   - Double-click the Ninite executable
   - Or right-click → **Run as administrator** (optional)

3. **Automatic Update Process**
   - Ninite automatically:
     - Checks each configured application
     - Downloads latest versions for outdated apps
     - Installs updates silently
     - Skips already up-to-date applications
   
4. **Review Results**
   - Wait for "All done!" message
   - Click **Show Details** to see what was updated
   - Applications updated by Ninite:
     - Google Chrome
     - 7-Zip
     - iTunes
     - Git
     - Notepad++
     - Visual Studio Code
     - Foxit Reader
     - Google Drive for Desktop

5. **Close Ninite**
   - No restart typically required
   - Applications are ready to use immediately

### Verification

Check versions of key applications:

```powershell
# Git version
git --version

# VS Code version (from VS Code)
code --version

# Chrome version (from Chrome)
# chrome://version
```

---

## 5️⃣ Development Tools (Manual Updates)

### PowerShell 7

**Update Method**: Microsoft Store (automatic) or manual

```powershell
# Check current version
pwsh --version

# Update via winget (alternative)
winget upgrade Microsoft.PowerShell
```

### Visual Studio (Full IDE)

If installed (separate from VS Code):

1. **Launch Visual Studio**
2. **Help → Check for Updates**
3. **Download and install updates**
4. **Restart Visual Studio**

Or use Visual Studio Installer:
- Start Menu → Visual Studio Installer
- Click **Update** next to installed version

### GitHub Desktop

1. **Launch GitHub Desktop**
2. **Help → Check for Updates**
3. **Downloads and installs automatically**

Or download latest from: [https://desktop.github.com](https://desktop.github.com)

---

## 6️⃣ Productivity & Communication Tools

### Office 365

**Frequency**: Automatic (background updates) or monthly check

**Update Method**: Automatic via Microsoft Update

1. **Check for Updates Manually** (optional)
   - Open any Office app (e.g., Excel)
   - File → Account → Update Options → Update Now

2. **Verify Current Version**
   - File → Account
   - Shows Office version and update channel

3. **Office Updates Automatically**
   - Updates download and install in background
   - No action typically required

### Microsoft Teams

**Frequency**: Automatic (updates in background)

**Update Method**:
- Microsoft Store version: Automatic
- Desktop version: Auto-updates during app start

1. **Check for Updates**
   - Teams → Profile picture → Settings → About
   - Shows current version
   - Teams checks for updates automatically on launch

2. **Force Update** (if needed)
   - Teams → Settings → General → Check for updates

### Slack

**Frequency**: Monthly or automatic

**Update Method**: Auto-updates in background

1. **Check for Updates**
   - Slack → Help → Check for Updates
   - Downloads and installs automatically if available

2. **Verify Version**
   - Slack → Help → About Slack
   - Shows current version

**Alternative**: Download latest installer from [slack.com/downloads](https://slack.com/downloads) and reinstall

---

## 7️⃣ Database & BI Tools

## 7️⃣ Database & BI Tools

### SQL Server 2025

**Frequency**: Quarterly (cumulative updates)  
**Caution**: Review release notes before updating production instances

1. **Check Current Version and CU Level**
   ```sql
   SELECT 
       SERVERPROPERTY('ProductVersion') AS Version,
       SERVERPROPERTY('ProductLevel') AS ProductLevel,
       SERVERPROPERTY('ProductUpdateLevel') AS CU,
       @@VERSION AS FullVersion;
   ```

2. **Check for Latest Cumulative Update**
   - Visit: [SQL Server 2025 Cumulative Updates](https://learn.microsoft.com/en-us/troubleshoot/sql/releases/download-and-install-latest-updates)
   - Note latest CU number and build
   - Review release notes and known issues

3. **Download Cumulative Update**
   - Download from Microsoft Update Catalog or direct link
   - File: `SQLServer2025-KB#######-x64.exe`

4. **Prepare for Update**
   - [ ] Close all applications connected to SQL Server
   - [ ] Backup critical databases (recommended)
   - [ ] Note current build number
   - [ ] Schedule maintenance window (updates require service restart)

5. **Install Cumulative Update**
   - Run downloaded .exe as administrator
   - Select MSSQLSERVER instance (default)
   - Select all features to update:
     - Database Engine
     - Analysis Services
     - Integration Services
     - Shared components
   - Accept license terms
   - Click Update
   - Wait for completion (10-20 minutes)
   - Services restart automatically

6. **Verify Update**
   ```sql
   SELECT @@VERSION;
   SELECT SERVERPROPERTY('ProductUpdateLevel') AS CU;
   ```

7. **Test Functionality**
   - Connect via SSMS
   - Verify databases online
   - Test key applications
   - Check SQL Server Agent jobs
   - Verify SSAS and SSIS services running

### SQL Server Management Studio (SSMS)

**Frequency**: Quarterly or when new version released

1. **Check Current Version**
   - Launch SSMS
   - Help → About Microsoft SQL Server Management Studio

2. **Check for Updates**
   - Visit: [https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
   - Download latest version if newer available

3. **Install Update**
   - Run installer
   - Choose "Upgrade" option
   - Restart if required

### SQL Server Management Studio (SSMS)

**Frequency**: Monthly (Microsoft releases monthly updates approximately)

1. **Check Current Version**
   - Launch SSMS
   - Help → About
   - Note version number (e.g., 20.2)

2. **Check for Updates**
   - Help → Check for Updates
   - Opens web browser with latest SSMS download page
   - Compare your version with latest available

3. **Download and Install Update**
   - Visit: [https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
   - Download latest `SSMS-Setup-ENU.exe`
   - Run installer as administrator
   - Click Install (upgrades existing installation automatically)
   - Wait for completion (10-20 minutes)
   - No uninstall needed

4. **Verify Update**
   - Launch SSMS
   - Help → About
   - Verify new version number

### Visual Studio Community 2019

**Frequency**: Monthly (updates released monthly)

1. **Check for Updates**
   - Launch Visual Studio 2019
   - Help → Check for Updates
   - Or use Visual Studio Installer

2. **Visual Studio Installer Method** (Recommended)
   - Start Menu → Visual Studio Installer
   - Shows available updates next to installed version
   - Click **Update** button if available
   - Select update options
   - Click **Update while downloading** or **Download all, then update**
   - Wait for completion (15-45 minutes)
   - Visual Studio restarts after update

3. **Update Extensions**
   - Extensions → Manage Extensions
   - Click **Updates** in left pane
   - Select all available updates
   - Click **Update**
   - Close Visual Studio to apply updates
   - Relaunch Visual Studio

4. **Critical Extensions to Update**
   - SQL Server Integration Services Projects
   - Microsoft Reporting Services Projects
   - Microsoft Analysis Services Projects

5. **Verify Update**
   - Help → About Microsoft Visual Studio
   - Shows updated version number

### Power BI Desktop (Standard Version)

**Frequency**: Monthly (Microsoft releases monthly updates)

**Update Methods**:

**Microsoft Store Version** (Recommended):
- Updates automatically through Microsoft Store
- Check manually: Microsoft Store → Library → Get updates
- No action typically required

**Direct Download Version**:

1. **Check Current Version**
   - Power BI Desktop → File → Help → About
   - Note version date (e.g., "May 2026")

2. **Check for Updates**
   - Power BI Desktop may notify on launch
   - Or visit: [https://powerbi.microsoft.com/desktop/](https://powerbi.microsoft.com/desktop/)

3. **Download and Install**
   - Download latest `PBIDesktopSetup_x64.exe`
   - Run installer
   - Automatically upgrades existing installation
   - Reports (.pbix files) remain compatible

4. **Review Release Notes**
   - [Power BI Blog](https://powerbi.microsoft.com/blog/)
   - Check new features and fixes

### Additional Software Updates

**Bitwarden**:
- Microsoft Store version: Auto-updates
- Desktop app: Help → Check for Updates
- Or download latest from [bitwarden.com](https://bitwarden.com/download/)

**WhatsApp Desktop**:
- Microsoft Store version: Auto-updates
- Direct download version: Auto-updates in background
- Or download latest from [whatsapp.com](https://www.whatsapp.com/download)

**Cyohash**:
- Check quarterly for updates
- Visit: [https://sourceforge.net/projects/cyohash/](https://sourceforge.net/projects/cyohash/)
- Download and install latest version if available

**Garmin Express**:
- Auto-updates when launched
- Updates Garmin devices automatically

**Remote Desktop Manager Free**:
- Help → Check for Updates
- Download from Devolutions website if update available

**MariaDB**:
- Check quarterly for new stable releases
- Visit: [https://mariadb.org/download/](https://mariadb.org/download/)
- Major version upgrades require careful planning (backup databases first)
- Minor version updates usually seamless

---

## 5️⃣ Development Tools (Manual Updates)
   - Launch Power BI Desktop
   - File → Help → About

2. **Check for Updates**
   - Power BI Desktop notifies on launch if update available
   - Or download from: [https://powerbi.microsoft.com/desktop](https://powerbi.microsoft.com/desktop)

3. **Install Update**
   - Download latest installer
   - Close Power BI Desktop
   - Run installer (upgrades in place)

### Azure Data Studio

1. **Launch Azure Data Studio**
2. **Help → Check for Updates**
3. **Downloads and installs automatically**

Or download from: [https://docs.microsoft.com/en-us/sql/azure-data-studio/download](https://docs.microsoft.com/en-us/sql/azure-data-studio/download)

### Power BI Report Server

**Frequency**: Quarterly (Microsoft releases quarterly updates)

1. **Check Current Version**
   - Open web browser
   - Navigate to: `http://localhost/Reports`
   - Click Settings (gear icon) → About
   - Note version and build number

2. **Check for Updates**
   - Visit: [https://powerbi.microsoft.com/report-server/](https://powerbi.microsoft.com/report-server/)
   - Compare installed version with latest available
   - Review release notes

3. **IMPORTANT: Backup Before Update**
   - **Backup Encryption Keys**:
     - Launch Report Server Configuration Manager
     - Connect to report server
     - Encryption Keys → Backup
     - Save to secure location with password
   - **Backup Databases** (optional but recommended):
     ```sql
     BACKUP DATABASE ReportServer TO DISK = 'C:\Backup\ReportServer.bak';
     BACKUP DATABASE ReportServerTempDB TO DISK = 'C:\Backup\ReportServerTempDB.bak';
     ```

4. **Download Update**
   - Download latest `PowerBIReportServer.exe` from download page
   - Save installer

5. **Install Update**
   - Close all browser windows accessing Report Server
   - Run `PowerBIReportServer.exe` as administrator
   - Installer detects existing installation
   - Select **Upgrade Power BI Report Server**
   - Follow prompts
   - Wait for completion (10-20 minutes)

6. **Update Power BI Desktop (Report Server Edition)**
   - Download matching version from same page
   - Must be compatible with Report Server version
   - Run `PBIDesktopRS.msi`
   - Installs/upgrades automatically

7. **Verify Update**
   - Navigate to: `http://localhost/Reports`
   - Settings → About
   - Verify new version number
   - Test publishing a report
   - Verify reports still accessible

8. **Post-Update Checks**
   - Verify Report Server service running
   - Check web portal accessible
   - Test report viewing and publishing
   - Verify scheduled subscriptions still working (if configured)

### DBeaver Community Edition

1. **Launch DBeaver**
2. **Help → Check for Updates**
3. **Download and install if available**

Or download latest from: [https://dbeaver.io/download/](https://dbeaver.io/download/)

---

## 7️⃣ Cloud Tools

### Google Cloud CLI (gcloud)

**Frequency**: Monthly

```powershell
# Check current version
gcloud --version

# Update gcloud components
gcloud components update

# Verify update
gcloud version
```

### Cloud SQL Proxy

Included in gcloud components update, or download latest binary from Google Cloud documentation.

---

## 8️⃣ Docker & WSL

### Docker Desktop

**Frequency**: Monthly or as released

1. **Check for Updates**
   - Docker Desktop → Settings → Software updates
   - Or Docker Desktop notifies when update available

2. **Download and Install**
   - Click **Download update**
   - Or download from: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)

3. **Install Update**
   - Quit Docker Desktop
   - Run installer
   - Restart Docker Desktop

```powershell
# Verify version
docker --version
docker-compose --version
```

### WSL

**Update WSL Itself**:

```powershell
# Update WSL to latest version
wsl --update

# Check version
wsl --version
```

**Update Linux Distribution** (Ubuntu example):

```bash
# From within WSL Ubuntu
sudo apt update
sudo apt upgrade -y

# Optional: Distribution upgrade
sudo apt dist-upgrade -y

# Clean up
sudo apt autoremove -y
```

---

## 🔟 VPN Clients

### FortiClient VPN

**Frequency**: Quarterly or as released (security updates may be more frequent)

1. **Check Current Version**
   - Launch FortiClient
   - Settings → About
   - Note version number

2. **Check for Updates**
   - FortiClient may auto-notify when update available
   - Or visit: [https://www.fortinet.com/support/product-downloads](https://www.fortinet.com/support/product-downloads)
   - Search for FortiClient VPN
   - Check latest version

3. **Download Update**
   - Download latest FortiClient VPN installer
   - File: `FortiClientVPN_[version]_x64.exe`

4. **Install Update**
   - Disconnect from any active VPN connection
   - Close FortiClient
   - Run installer as administrator
   - Installer upgrades existing installation
   - Click through wizard (typically defaults are fine)
   - Restart if prompted

5. **Verify Update**
   - Launch FortiClient
   - Settings → About → Check version number
   - Test VPN connection to client network
   - Verify saved profiles still work

### OpenVPN

**Frequency**: As released (check quarterly or when client updates infrastructure)

1. **Check Current Version**
   - Launch OpenVPN Connect
   - Settings → About
   - Note version number

2. **Check for Updates**
   - Visit: [https://openvpn.net/client-connect-vpn-for-windows/](https://openvpn.net/client-connect-vpn-for-windows/)
   - Compare with installed version
   - Or check Microsoft Store for updates (if installed from Store)

3. **Microsoft Store Version**
   - Updates automatically through Microsoft Store
   - Microsoft Store → Library → Get updates

4. **Direct Download Version**
   - Download latest `OpenVPN-Connect-v3-Windows.msi`
   - Run installer
   - Upgrades existing installation
   - VPN profiles are preserved

5. **Verify Update**
   - Launch OpenVPN Connect
   - Check version in About
   - Verify saved profiles are still present
   - Test connection to client VPN

---

## 1️⃣1️⃣ PowerShell Modules

**Frequency**: Quarterly

```powershell
# Check installed modules
Get-InstalledModule

# Update all modules
Update-Module

# Update specific modules
Update-Module -Name SqlServer
Update-Module -Name Az

# Verify updates
Get-InstalledModule | Sort-Object -Property Name
```

---

## ✅ Post-Update Verification

After completing all updates:

### System Health Checks

1. **Verify Windows Version**
   ```powershell
   winver
   Get-ComputerInfo | Select-Object WindowsVersion, OsBuildNumber
   ```

2. **Check BIOS Version**
   ```powershell
   Get-ComputerInfo | Select-Object BiosVersion
   ```

3. **Verify Services Running**
   ```powershell
   # Check SQL Server service (if installed)
   Get-Service -Name MSSQL*
   
   # Check Docker service
   Get-Service -Name com.docker.service
   ```

4. **Test Key Applications**
   - [ ] Office apps launch (Excel, Word, Outlook)
   - [ ] Teams launches and connects
   - [ ] Slack launches and connects to workspaces
   - [ ] WhatsApp Desktop launches and syncs
   - [ ] VS Code launches
   - [ ] Visual Studio 2019 launches
   - [ ] Visual Studio 2026 launches
   - [ ] Git works: `git --version`
   - [ ] PowerShell 7: `pwsh --version`
   - [ ] Docker: `docker ps`
   - [ ] WSL: `wsl uname -a`
   - [ ] SSMS connects to SQL Server
   - [ ] SQL Server databases online and accessible
   - [ ] MariaDB service running (if installed)
   - [ ] SSAS service running
   - [ ] SSIS service running
   - [ ] DBeaver connects to databases
   - [ ] Power BI Desktop opens reports
   - [ ] Power BI Report Server web portal accessible
   - [ ] Bitwarden unlocks with master password

5. **Check Internet Connectivity**
   ```powershell
   Test-NetConnection google.com
   Test-NetConnection github.com
   ```

---

## 📋 Monthly Update Checklist

Copy this checklist for each monthly update session:

**Update Date**: [____________________]

### Dell & Windows
- [ ] Dell SupportAssist - Check for updates
- [ ] Dell Drivers installed
- [ ] Dell BIOS updated (if available)
- [ ] Windows Updates - All installed
- [ ] Windows Update - No pending restarts
- [ ] System restarted if required

### Core Utilities
- [ ] Ninite installer run
- [ ] Chrome, Git, VS Code, etc. updated
- [ ] Microsoft Store apps updated

### Productivity & Communication
- [ ] Office 365 updated (check any Office app → Account → Updates)
- [ ] Microsoft Teams updated
- [ ] Slack updated
- [ ] WhatsApp Desktop updated (Microsoft Store or auto-update)

### Development Tools
- [ ] PowerShell 7 updated (Microsoft Store)
- [ ] Visual Studio 2019 updated
- [ ] Visual Studio 2019 extensions updated
- [ ] Visual Studio 2026 updated
- [ ] Visual Studio 2026 extensions updated
- [ ] GitHub Desktop updated (if installed)
- [ ] WSL updated
- [ ] WSL Ubuntu packages updated
- [ ] Docker Desktop updated

### Database & BI Tools
- [ ] SQL Server 2025 - Latest CU reviewed (quarterly)
- [ ] SQL Server 2025 CU installed (if applicable)
- [ ] SSMS checked for updates
- [ ] SSMS updated if new version available
- [ ] Azure Data Studio updated
- [ ] Power BI Desktop (standard) updated
- [ ] Power BI Report Server checked (quarterly)
- [ ] Power BI Report Server updated (if applicable)
- [ ] DBeaver updated
- [ ] MariaDB checked for updates (quarterly)

### Additional Software & Utilities
- [ ] Bitwarden updated (Microsoft Store or desktop app)
- [ ] WhatsApp Desktop updated
- [ ] Gyazo updated
- [ ] Garmin Express updated (auto-updates)
- [ ] Remote Desktop Manager checked for updates

### Cloud & VPN
- [ ] Google Cloud CLI updated
- [ ] FortiClient VPN checked (quarterly)
- [ ] OpenVPN checked (if used)
- [ ] PowerShell modules updated

### Verification
- [ ] All applications launch successfully
- [ ] No error messages or warnings
- [ ] Services running correctly (SQL Server, SSAS, SSIS, Docker)
- [ ] VPN connects successfully (FortiClient or OpenVPN)
- [ ] Can access client resources (if domain-joined)
- [ ] Can access databases (local and remote via VPN)
- [ ] Teams and Slack connect to workspaces
- [ ] Office 365 apps activated and working

### Notes
_Any issues encountered or deferred updates:_

---

---

## 🐛 Troubleshooting

### Windows Update Fails

**Issue**: Updates fail to install or error occurs

**Solutions**:
1. Run Windows Update Troubleshooter:
   - Settings → System → Troubleshoot → Other troubleshooters → Windows Update
2. Clear Windows Update cache:
   ```powershell
   Stop-Service -Name wuauserv
   Remove-Item C:\Windows\SoftwareDistribution\Download\* -Recurse -Force
   Start-Service -Name wuauserv
   ```
3. Run DISM and SFC:
   ```powershell
   DISM /Online /Cleanup-Image /RestoreHealth
   sfc /scannow
   ```

### BIOS Update Hangs

**Issue**: BIOS update seems stuck

**Solutions**:
- Wait patiently (can take 15-20 minutes)
- Do NOT power off
- If truly frozen (>30 min with no progress), contact Dell support

### Ninite Updates Fail

**Issue**: Specific apps fail to update via Ninite

**Solutions**:
1. Update manually from official website
2. Uninstall and reinstall via Ninite
3. Check antivirus isn't blocking

### Docker Won't Start After Update

**Issue**: Docker Desktop fails to start after update

**Solutions**:
1. Restart computer
2. Ensure WSL 2 is running: `wsl --version`
3. Restart WSL: `wsl --shutdown` then restart Docker Desktop
4. Reinstall Docker Desktop if needed

---

## 📝 Update Log Template

Keep a log of major updates:

```
=== Update Log ===

Date: [2026-XX-XX]

BIOS:
- Version: [X.X.X]
- Previous: [X.X.X]
- Notes: [Resolved issue with...]

Windows:
- Build: [XXXXX.XXX]
- Updates installed: [KB#####, KB#####]

Applications:
- Power BI Desktop: [Version]
- SSMS: [Version]
- Docker Desktop: [Version]

Issues:
- [None / describe any issues]

Next Update: [First week of MONTH]
```

---

## 🔗 Related Documentation

- **Dell SupportAssist**: [Installation Guide](../installation/dell-supportassist.md)
- **Ninite**: [Installation Guide](../installation/ninite.md)
- **Additional Dev Tools**: [Installation Guide](../installation/additional-dev-tools.md)

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Systematic approach to software maintenance and updates
