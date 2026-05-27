# Windows 11 Fresh Installation via Reset This PC

## 🖥️ Hardware Information

**Laptop Model**: Dell XPS 13 9310  
**Computer Name**: MIRZAKHANI  
**RAM**: 32 GB  
**Storage**: 1 TB SSD  
**OS**: Windows 11

This guide covers performing a complete Windows 11 reset using the built-in "Reset this PC" feature, which will erase all data and provide a clean installation.

---

## ⚠️ Critical Pre-Reset Checklist

Before proceeding, ensure you have completed ALL of the following:

### Data Backup
- [ ] Backup all important documents, projects, and personal files to external storage or cloud
- [ ] Export browser bookmarks and saved passwords
- [ ] Save any custom application settings or configurations
- [ ] Export email accounts and settings (if using local email client)
- [ ] Backup SSH keys, Git credentials, and development certificates
- [ ] Save any license keys for installed software
- [ ] Document installed programs you'll need to reinstall
- [ ] Backup any custom fonts, templates, or resources

### Client Work Backup
- [ ] Ensure all client projects are committed and pushed to remote repositories
- [ ] Download any client-specific files, documentation, or resources
- [ ] Save database connection strings and access credentials (store securely, NOT in Git)
- [ ] Export any custom SQL scripts or queries
- [ ] Backup Power BI templates and custom visuals
- [ ] Save SSRS/SSIS/SSAS project files

### Credentials & Licenses
- [ ] Document all software licenses and product keys
- [ ] Save Microsoft account credentials
- [ ] Save GitHub/Azure DevOps access tokens
- [ ] Note SQL Server authentication details
- [ ] Store client VPN configurations and credentials (securely)
- [ ] Save any certificates required for client access

### Hardware & Drivers
- [ ] Download latest Dell XPS 13 9310 drivers from Dell Support website
- [ ] Save Dell SupportAssist or other Dell utilities installers
- [ ] Note current BIOS version (for reference)
- [ ] Document any hardware-specific settings

### Internet Connection
- [ ] Ensure stable internet connection (reset process may require downloads)
- [ ] Have WiFi password available (will be needed after reset)
- [ ] Consider using Ethernet connection if available for stability

---

## 📋 Reset Process

### Step 1: Access Windows Reset Feature

1. **Open Settings**
   - Press `Win + I` to open Settings
   - Or: Click Start → Settings

2. **Navigate to Recovery**
   - Select **System** from the left sidebar
   - Scroll down and click **Recovery**

3. **Initiate Reset**
   - Under "Recovery options", find **Reset this PC**
   - Click the **Reset PC** button

### Step 2: Choose Reset Options

1. **Remove Everything**
   - When prompted "Choose an option", select **Remove everything**
   - This will erase all personal files, apps, and settings

2. **Reinstallation Method**
   - Choose **Local reinstall** (uses existing Windows files on the device)
   - Alternative: **Cloud download** (downloads fresh Windows files from Microsoft)
   - *Recommendation*: Use **Cloud download** for cleanest installation

3. **Additional Settings**
   - Click **Change settings** to view additional options
   - Enable **Clean data** option (performs secure erase, takes longer but more thorough)
   - Enable **Download Windows** if you selected cloud download
   - Confirm settings

4. **Review Summary**
   - Review what will be removed
   - Confirm the reset process
   - Click **Next**

### Step 3: Final Confirmation

1. **Ready to Reset**
   - Windows will display a final summary
   - List of apps that will be removed is shown
   - Click **Reset** to begin

2. **Reset Process Begins**
   - Computer will restart multiple times
   - Progress indicator will show percentage complete
   - **Do not turn off the computer or interrupt the process**
   - Process duration: 30-90 minutes (depending on clean data option and hardware)

### Step 4: Windows 11 Setup (OOBE - Out of Box Experience)

After reset completes, you'll go through the Windows setup wizard:

1. **Region & Keyboard**
   - Select your country/region
   - Choose keyboard layout
   - Add additional keyboard layouts if needed

2. **Network Connection**
   - Connect to WiFi network
   - Enter WiFi password
   - Windows will check for updates

3. **Microsoft Account**
   - Sign in with your Microsoft account
   - Or: Create a new account
   - Set up Windows Hello (fingerprint/face recognition) if desired

4. **Privacy Settings**
   - Review and configure privacy settings
   - Choose what data to share with Microsoft
   - *Recommendation*: Review each setting carefully

5. **Device Setup**
   - Choose setup type: Personal or Work/School
   - *Select*: **Set up for personal use**
   - Complete OneDrive setup if desired

6. **Finalize Setup**
   - Let Windows complete final configuration
   - Computer may restart once more

---

## ✅ Post-Reset Verification

After Windows 11 is installed and you're at the desktop:

### Immediate Checks

1. **Verify Computer Name**
   - Press `Win + Pause/Break` or right-click This PC → Properties
   - Computer name may have changed during reset
   - **Rename to**: MIRZAKHANI
   - Path: Settings → System → About → Rename this PC
   - Restart when prompted

2. **Check Windows Activation**
   - Settings → System → Activation
   - Verify Windows 11 is activated
   - Should activate automatically if using Microsoft account

3. **Windows Updates**
   - Settings → Windows Update
   - Click **Check for updates**
   - Install all available updates
   - Restart as needed
   - Repeat until no more updates available

4. **Verify Hardware Recognition**
   - Open Device Manager (`Win + X` → Device Manager)
   - Check for any devices with yellow warning icons
   - All hardware should be recognized

### Dell-Specific Setup

1. **Dell Drivers & Utilities**
   - Visit [Dell Support for XPS 13 9310](https://www.dell.com/support/home/product-support/product/xps-13-9310-laptop)
   - Download and install:
     - Dell Command | Update (automatic driver updates)
     - Dell SupportAssist
     - Any missing drivers
   - Or use Dell Command | Update to automatically install all drivers

2. **BIOS Update** (if needed)
   - Check current BIOS version: Run `msinfo32`, check BIOS Version/Date
   - Download latest BIOS from Dell Support if available
   - Follow Dell's BIOS update instructions carefully

### System Configuration

1. **Display Settings**
   - Verify display resolution and scaling (Settings → System → Display)
   - XPS 13 9310 typically uses 125-150% scaling

2. **Power Settings**
   - Configure power plan (Settings → System → Power)
   - Set sleep and screen timeout preferences

3. **Storage Check**
   - Verify available storage space
   - Should have ~950+ GB free on 1TB SSD (after Windows installation)

---

## 🚀 Next Steps

After completing the fresh Windows 11 installation:

1. **Install Dell SupportAssist for Business PCs**
   - See: [Dell SupportAssist Installation Guide](dell-supportassist.md)
   - Essential for Dell firmware, BIOS, and driver updates
   - Run initial scan and install all available updates
   - Keep BIOS and drivers up to date for optimal performance

2. **Proceed to System Configuration**
   - See: `docs/configuration/windows-settings.md`
   - Configure Windows 11 preferences and optimizations

3. **Install Core Utilities via Ninite**
   - See: [Ninite Installation Guide](ninite.md)
   - Single installer for: Chrome, 7-Zip, iTunes, Git, Notepad++, VS Code, Foxit Reader, Google Drive
   - Save the Ninite .exe for future updates
   - Duration: 10-30 minutes depending on internet speed

4. **Install Additional Development Tools**
   - See: [Additional Development Tools Guide](additional-dev-tools.md)
   - PowerShell 7, WSL, Docker Desktop, DBeaver, Google Cloud CLI
   - Duration: 30-60 minutes

5. **Install and Configure VPN**
   - See: [FortiClient VPN Installation Guide](fortinet-vpn.md)
   - Required for connecting to client network and domain join
   - Configure VPN connection with client details

4. **Join Active Directory Domain**
   - See: [Domain Join Configuration Guide](../configuration/domain-join.md)
   - Connect to VPN before attempting domain join
   - Use domain credentials to login after joining

5. **Install Additional Development Tools**
   - After domain join is complete:
     - GitHub Desktop (Git already installed via Ninite)
     - Visual Studio (full IDE, if needed - VS Code already installed via Ninite)
     - SQL Server components (SSMS, SSDT, etc.)
     - Power BI Desktop and BI tools
   - Follow the recommended installation order in main README.md

6. **Restore Backed-Up Data**
   - Restore personal files from backup
   - Clone Git repositories
   - Restore custom configurations

---

## 📝 Notes & Tips

### Performance After Reset
- First boot and initial setup may take 20-30 minutes
- Windows Search indexing will run in background (may impact performance initially)
- Let Windows complete all updates before heavy development work

### Common Issues

**Issue**: WiFi not connecting after reset  
**Solution**: Restart router, forget and re-add network, or install Dell WiFi drivers manually

**Issue**: Windows not activated  
**Solution**: Ensure internet connection is active; activation may take a few hours; use Microsoft account linked to previous activation

**Issue**: Missing drivers in Device Manager  
**Solution**: Run Windows Update multiple times; install Dell Command | Update; manually download from Dell Support

**Issue**: Slow performance immediately after reset  
**Solution**: Normal - Windows is indexing files and completing setup; wait 30-60 minutes

### Security Considerations

- Enable Windows Defender immediately (should be on by default)
- Set up Windows Hello for secure authentication
- Configure BitLocker if needed for client work (Pro/Enterprise edition required)
- Install updates before connecting to client networks

### Dell XPS 13 9310 Specific Notes

- Ensure latest Intel chipset and graphics drivers are installed
- Thunderbolt 4 ports may require specific Dell drivers
- Killer WiFi adapter may benefit from latest Dell drivers vs. generic Windows drivers
- XPS may have Dell-specific features requiring Dell applications

---

## 🔄 Alternative: Windows 11 Clean Install via USB

If "Reset this PC" fails or you prefer a completely clean installation:

1. Create Windows 11 installation USB using Microsoft Media Creation Tool
2. Boot from USB (F12 during Dell startup)
3. Delete all partitions during installation (full clean install)
4. Install Windows 11 fresh
5. See separate guide: `windows-11-usb-install.md` (if created)

---

## 📅 Reset Information

**Last Performed**: [To be filled after reset]  
**Windows Version After Reset**: Windows 11 [version number]  
**Duration**: [Actual time taken]  
**Issues Encountered**: [None / List any issues]

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Fresh start for BI development environment setup
