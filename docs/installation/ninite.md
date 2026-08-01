# Ninite - Automated Software Installation & Updates

## 📋 Overview

Ninite is a free tool that automatically installs and updates multiple applications with a single executable. It's used in this setup to manage core utilities, development tools, and essential software with minimal effort.

**Website**: [https://ninite.com](https://ninite.com)

**Benefits**:
- No toolbars, bundled software, or adware
- Automatic updates when re-run
- Silent installation (no user interaction required)
- Installs latest versions
- Can be saved and re-used for updates

---

## 📦 Selected Software Package

The following software is included in our Ninite configuration:

### Browsers
- **Google Chrome** - Primary web browser for development and testing

### Utilities
- **7-Zip** - File compression and extraction
- **Foxit Reader** - PDF viewer and editor alternative to Adobe Reader
- **Google Drive for Desktop** - Cloud storage and file sync

### Development Tools
- **Git** - Version control system
- **Notepad++** - Advanced text editor
- **Visual Studio Code** - Primary code editor and IDE

### Media & Productivity
- **iTunes** - Media library and device management

---

## 🔧 Creating Your Ninite Installer

### Step 1: Visit Ninite Website

1. Open browser and go to: [https://ninite.com](https://ninite.com)
2. You'll see a list of available applications organized by category

### Step 2: Select Applications

Select the following applications by checking their boxes:

**Web Browsers**
- [ ] Chrome

**Utilities** (scroll down to this section)
- [ ] 7-Zip

**Media**
- [ ] iTunes

**Runtimes** (skip if not needed separately, VS Code includes what it needs)

**Imaging** (scroll down)
- [ ] Foxit Reader

**Documents** (scroll down)
- [ ] Google Drive for Desktop

**Developer Tools**
- [ ] Git
- [ ] Notepad++
- [ ] Visual Studio Code

### Step 3: Download Installer

1. After selecting all applications, scroll to the bottom of the page
2. Click **Get Your Ninite** button
3. A custom installer will be downloaded: `Ninite [App Names] Installer.exe`
4. File size: Typically small (1-3 MB) - it downloads actual installers when run

### Step 4: Save for Future Use

1. **Recommended location**: 
   ```
   C:\Tools\Ninite\
   ```
   or
   ```
   C:\Users\[Username]\Software\Ninite\
   ```

2. **Rename for clarity** (optional):
   ```
   Ninite_CoreUtilities_[Date].exe
   ```
   Example: `Ninite_CoreUtilities_2026-05-27.exe`

3. **Save in multiple locations**:
   - Local drive for quick access
   - OneDrive/Google Drive for backup
   - USB drive for offline installation

---

## 💾 Initial Installation

### First-Time Setup

1. **Disconnect from VPN** (if connected)
   - Ninite works better on unrestricted internet connection
   - Reconnect to VPN after installation if needed

2. **Run as Administrator** (recommended but not always required)
   - Right-click the Ninite executable
   - Select **Run as administrator**
   - Click **Yes** on UAC prompt

3. **Installation Process**
   - Ninite will automatically:
     - Download latest versions of all selected apps
     - Install silently (no prompts or user interaction)
     - Skip apps already installed at latest version
     - Update apps that are outdated
   - Progress window shows installation status for each app

4. **Duration**
   - Typical installation time: 10-30 minutes
   - Depends on internet speed and number of apps
   - Can continue working during installation

5. **Completion**
   - "All done!" message when complete
   - Shows which apps were installed/updated
   - Click **Show Details** to see what happened with each app
   - Close window when finished

### Installation Notes

**What Ninite Does**:
- ✅ Installs to default locations (usually `C:\Program Files`)
- ✅ Uses 64-bit versions when available
- ✅ Declines all bundled offers and toolbars
- ✅ Skips already up-to-date applications
- ✅ Runs installers in silent mode

**What Ninite Doesn't Do**:
- ❌ Doesn't ask for installation preferences
- ❌ Doesn't let you choose installation directory
- ❌ Doesn't install if custom version already exists
- ❌ Doesn't uninstall applications

---

## 🔄 Updating Software with Ninite

### Regular Updates

**Recommended Schedule**: Run Ninite monthly or after Windows updates

1. **Launch Saved Executable**
   - Navigate to where you saved the Ninite installer
   - Double-click or run as administrator
   - Same .exe file works for both installation and updates

2. **Automatic Update Process**
   - Ninite checks each application
   - Updates only outdated software
   - Skips apps already at latest version
   - Shows results when complete

3. **No Internet Required for Check**
   - Can run offline to see status
   - Needs internet to download updates

### Update Workflow Example

```powershell
# Optional: Create a scheduled task to remind about updates
# Or create a simple PowerShell script

# Navigate to Ninite folder
cd C:\Tools\Ninite

# Run Ninite (updates all configured apps)
.\Ninite_CoreUtilities.exe
```

### Creating a Monthly Update Reminder

1. **Option A: Calendar Reminder**
   - Add monthly recurring event
   - "Run Ninite Updates"

2. **Option B: Windows Task Scheduler** (notification only)
   - Create task to show reminder
   - Don't auto-run (Ninite should be manually reviewed)

3. **Option C: Manual Tracking**
   - Keep notes in this repo or task manager
   - Check monthly along with Windows updates

---

## ✅ Post-Installation Verification

After Ninite installation completes:

### Verify Each Application

1. **Google Chrome**
   - Launch Chrome
   - Check version: Settings → About Chrome
   - Sign in to Google account (optional)
   - Install extensions as needed

2. **7-Zip**
   - Right-click any file
   - Should see "7-Zip" in context menu
   - Test extracting/compressing a file

3. **Git**
   - Open Command Prompt or PowerShell
   - Run: `git --version`
   - Should display installed Git version
   - Configure Git (see Git configuration guide)

4. **Notepad++**
   - Launch from Start Menu
   - File → Settings → Preferences (customize as needed)

5. **Visual Studio Code**
   - Launch VS Code
   - Install extensions (see VS Code configuration guide)
   - Sign in with GitHub/Microsoft account

6. **Foxit Reader**
   - Open a PDF file
   - Set as default PDF reader if desired
   - Configure preferences

7. **Google Drive for Desktop**
   - Launch from system tray or Start Menu
   - Sign in to Google account
   - Configure sync folders
   - Choose sync mode (stream or mirror)

8. **iTunes**
   - Launch iTunes
   - Sign in with Apple ID
   - Configure library location

### Configure Default Applications

After installation, set default apps if needed:

- Settings → Apps → Default apps
- Set Chrome as default browser
- Set Foxit Reader as default PDF viewer

---

## 🔧 Git Configuration (Post-Ninite)

After Ninite installs Git, configure it:

```powershell
# Set user name and email
git config --global user.name "Your Name"
git config --global user.email "your.email@domain.com"

# Set default branch name
git config --global init.defaultBranch main

# Set default editor (VS Code)
git config --global core.editor "code --wait"

# Verify configuration
git config --list
```

---

## 📝 Additional Software Not in Ninite

Some required software must be installed separately:

### Cannot Install via Ninite:
- **FortiClient VPN** - See: [FortiClient Installation Guide](fortinet-vpn.md)
- **SQL Server** - See: SQL Server installation guide
- **SQL Server Management Studio (SSMS)** - Separate installation
- **Power BI Desktop** - Download from Microsoft
- **Visual Studio** (full IDE) - VS Code is different from Visual Studio
- **Office 365** - Separate Microsoft installation
- **Dell drivers and utilities** - From Dell Support

---

## 🎯 Alternative: Ninite Pro

**Note**: This setup uses free Ninite. Ninite Pro is available for businesses.

**Ninite Pro Features** (paid, not required for this setup):
- Remote machine updates
- Command-line interface
- Offline installer cache
- Custom reports
- Scheduled updates

**For personal/freelance use**: Free Ninite is sufficient.

---

## 🔄 Refreshing Your Ninite Installer

If you need to add or remove applications:

1. **Visit Ninite.com again**
2. **Select new combination of apps**
3. **Download new installer**
4. **Replace or keep both versions**
   - Old installer still updates its apps
   - New installer manages new configuration
   - Can keep separate installers for different purposes

### Multiple Ninite Configurations

You could create separate installers for:
- **Core Utilities** (this guide's configuration)
- **Client-Specific Tools** (varies by client)
- **Optional Tools** (try new software)

Each .exe maintains its own list of applications.

---

## 🐛 Troubleshooting

### Ninite Won't Run

**Issue**: Double-clicking does nothing or shows error

**Solutions**:
1. Run as administrator
2. Disable antivirus temporarily (Ninite is safe)
3. Check internet connection
4. Download fresh copy from ninite.com

### Application Fails to Install

**Issue**: Ninite shows "Error" or "Failed" for specific app

**Solutions**:
1. Manually install that specific app
2. Check if app is already installed (different version)
3. Ensure enough disk space
4. Check Windows update requirements for that app
5. Review Ninite details for specific error message

### Application Already Installed

**Issue**: Ninite says app is already installed but you want to reinstall

**Solutions**:
1. Uninstall existing version manually first
2. Then re-run Ninite
3. Or install latest version manually

### Updates Not Detected

**Issue**: Ninite shows all apps up to date but you know updates exist

**Solutions**:
1. Ninite uses its own update schedule (usually within days of releases)
2. Check individual apps for updates manually if critical
3. Download fresh Ninite installer

---

## 📋 Installation Checklist

- [ ] Visit ninite.com
- [ ] Select all 8 applications (Chrome, 7-Zip, iTunes, Git, Notepad++, VS Code, Foxit Reader, Google Drive)
- [ ] Download Ninite installer
- [ ] Save installer to `C:\Tools\Ninite\` or preferred location
- [ ] Back up installer to cloud storage
- [ ] Run installer as administrator
- [ ] Wait for all installations to complete
- [ ] Verify each application launches
- [ ] Configure Git user settings
- [ ] Sign in to Chrome, Google Drive (if using)
- [ ] Set default applications (browser, PDF reader)
- [ ] Configure VS Code extensions
- [ ] Set monthly reminder to run Ninite for updates

---

## 🔗 Related Documentation

- **Git Configuration**: See development environment configuration guide
- **VS Code Setup**: See VS Code configuration guide
- **Post-Installation**: Continue with main README.md installation order

---

## 📅 Software Information

**Ninite Configuration**: Core Utilities Package  
**Applications**: 8 selected  
**Last Ninite Download**: [To be filled]  
**Last Update Run**: [To be filled]  
**Next Scheduled Update**: [Monthly]

**Selected Applications**:
1. Google Chrome
2. 7-Zip
3. iTunes
4. Git
5. Notepad++
6. Visual Studio Code
7. Foxit Reader
8. Google Drive for Desktop

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Streamlined installation and maintenance of core utilities
