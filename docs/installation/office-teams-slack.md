# Office 365, Microsoft Teams & Slack Installation

## 📋 Overview

This guide covers the installation of productivity and communication tools essential for freelance BI work and client collaboration.

**Software Covered**:
- **Office 365** - Productivity suite (Word, Excel, PowerPoint, Outlook, etc.)
- **Microsoft Teams** - Microsoft collaboration and communication platform
- **Slack** - Team collaboration and messaging platform

---

## 📦 Office 365

### Overview

Office 365 provides essential productivity applications including Excel (critical for BI work), Word, PowerPoint, Outlook, and OneDrive.

**License**: Personal/Business license required

### Installation

#### Method 1: Microsoft Account Portal (Recommended)

1. **Sign in to Microsoft Account**
   - Visit: [https://www.office.com](https://www.office.com)
   - Click **Sign In**
   - Use your Microsoft account with Office 365 license

2. **Install Office**
   - Click **Install Office** → **Office 365 apps**
   - Or: Click your profile → **View account** → **Install Office**
   - Download: `OfficeSetup.exe`

3. **Run Installer**
   - Run the downloaded `OfficeSetup.exe`
   - No interaction required - automatic installation
   - Downloads and installs latest Office 365 apps
   - Duration: 15-30 minutes depending on internet speed

4. **Activation**
   - Office apps activate automatically with signed-in Microsoft account
   - Launch any Office app to verify activation
   - Sign in with your Microsoft account if prompted

#### Method 2: Microsoft 365 Admin Center (Business License)

If you have a business license through a client or organization:

1. **Access Admin Portal**
   - Visit: [https://admin.microsoft.com](https://admin.microsoft.com)
   - Sign in with business account

2. **Download Office**
   - Navigate to **Settings** → **Org settings** → **Services** → **Office installation options**
   - Or direct download from [https://portal.office.com](https://portal.office.com)

3. **Install and Activate**
   - Run installer
   - Sign in with business account
   - Office activates with organizational license

### Configuration

1. **Launch Office Applications**
   - Start Menu → Search for Excel, Word, Outlook, etc.

2. **Sign In**
   - If not already signed in, use your Microsoft account
   - Choose **Work or School account** if using business license

3. **Configure Outlook** (if using email)
   - Launch Outlook
   - Add email account
   - Configure email settings

4. **OneDrive Setup**
   - OneDrive for Business may install with Office
   - Sign in to sync files
   - Configure sync folders

### Verification

```powershell
# Check installed Office version
Get-ItemProperty HKLM:\Software\Microsoft\Office\ClickToRun\Configuration | Select-Object VersionToReport

# Or launch any Office app and check
# File → Account → About [Application Name]
```

**Check Activation**:
- Open any Office app (e.g., Excel)
- File → Account
- Product Information should show "Product Activated"

### Updates

Office 365 updates automatically:
- Updates download in background
- File → Account → Update Options → Update Now (manual check)
- Or: Office updates through Microsoft Update automatically

---

## 💬 Microsoft Teams

### Overview

Microsoft Teams is Microsoft's collaboration platform for chat, video meetings, file sharing, and team collaboration.

### Installation

#### Method 1: Microsoft Store (Recommended for Windows 11)

1. **Open Microsoft Store**
   - Start Menu → Microsoft Store

2. **Search for Teams**
   - Search: "Microsoft Teams"
   - Select **Microsoft Teams** (personal or work version as needed)

3. **Install**
   - Click **Get** or **Install**
   - Automatic installation
   - No restart required

#### Method 2: Web Download

1. **Download Teams**
   - Visit: [https://www.microsoft.com/en-us/microsoft-teams/download-app](https://www.microsoft.com/en-us/microsoft-teams/download-app)
   - Click **Download Teams**
   - Choose version:
     - **Teams for Work or School** (most common)
     - **Teams for Personal** (personal Microsoft account)

2. **Run Installer**
   - Run downloaded installer: `Teams_windows_x64.exe`
   - Installs to user profile (no admin required)
   - Automatic installation
   - Teams launches after installation

### Configuration

1. **Sign In**
   - Launch Teams from Start Menu
   - Sign in with:
     - **Work or School account** (Office 365 account)
     - Or **Personal Microsoft account**

2. **Configure Settings**
   - Click profile picture → **Settings**
   - Configure:
     - Notifications preferences
     - Audio/video devices
     - Theme (Light/Dark/High Contrast)
     - Auto-start on login

3. **Join Teams**
   - Join client teams/channels as invited
   - Configure team notifications

### Verification

- Teams should launch successfully
- Can make test call: **Make a test call** in Settings → Devices
- Check for updates: Settings → About → Check for updates

### Updates

- Microsoft Store version: Updates automatically
- Desktop version: Auto-updates in background
- Manual check: Settings → About → Check for updates

---

## 💬 Slack

### Overview

Slack is a popular team collaboration platform used by many clients and software houses.

### Installation

#### Method 1: Web Download (Recommended)

1. **Download Slack**
   - Visit: [https://slack.com/downloads/windows](https://slack.com/downloads/windows)
   - Click **Download (64-bit)**
   - Downloads: `SlackSetup.exe`

2. **Run Installer**
   - Run downloaded installer
   - No interaction required
   - Installs automatically to user profile
   - Slack launches after installation

3. **Sign In**
   - Enter workspace URL or email
   - Sign in to your Slack workspace(s)
   - Can sign in to multiple workspaces

#### Method 2: Microsoft Store

1. **Open Microsoft Store**
2. **Search for "Slack"**
3. **Install**
   - Click **Get**
   - Automatic installation

### Configuration

1. **Add Workspaces**
   - Click workspace name → **Sign in to another workspace**
   - Enter workspace URL (e.g., `client.slack.com`)
   - Sign in with credentials

2. **Configure Preferences**
   - Click profile picture → **Preferences**
   - Configure:
     - Notifications (important for client communication)
     - Theme (Light/Dark/Sync with system)
     - Launch Slack on login
     - Notification schedule (Do Not Disturb hours)
     - Sidebar preferences

3. **Desktop Notifications**
   - Preferences → Notifications
   - Choose notification settings:
     - All new messages
     - Direct messages, mentions & keywords (recommended)
     - Nothing

### Tips for Multiple Client Workspaces

1. **Organize Workspaces**
   - Slack supports multiple workspaces in one app
   - Switch between workspaces: `Ctrl+1`, `Ctrl+2`, etc.

2. **Notification Management**
   - Set different notification preferences per workspace
   - Use notification schedules to avoid off-hours alerts

3. **Status Management**
   - Set custom status when working for specific clients
   - Use status to indicate availability

### Verification

- Slack launches successfully
- Can sign in to workspace(s)
- Notifications working
- Audio/video calls functional (test if needed)

### Updates

- Slack updates automatically in background
- Manual check: Help → Check for Updates
- Or download and run latest installer

---

## ✅ Post-Installation Checklist

### Office 365
- [ ] Office 365 installed successfully
- [ ] All Office apps launch (Word, Excel, PowerPoint, Outlook)
- [ ] Office activated (File → Account shows "Product Activated")
- [ ] Signed in with Microsoft account
- [ ] OneDrive configured (if using)
- [ ] Outlook email configured (if using email)

### Microsoft Teams
- [ ] Teams installed and launches
- [ ] Signed in with work/school or personal account
- [ ] Audio and video devices configured
- [ ] Made test call successfully
- [ ] Joined required teams/channels
- [ ] Notifications configured
- [ ] Auto-start configured (if desired)

### Slack
- [ ] Slack installed and launches
- [ ] Signed in to all required workspaces
- [ ] Notifications configured for each workspace
- [ ] Do Not Disturb schedule set
- [ ] Audio/video tested (if using for calls)
- [ ] Desktop notifications working

---

## 🔄 Monthly Updates

All three applications update automatically:

**Office 365**:
- Updates via Microsoft Update automatically
- Manual check: Any Office app → File → Account → Update Options → Update Now

**Microsoft Teams**:
- Auto-updates in background (desktop version)
- Microsoft Store version updates automatically
- Manual check: Settings → About → Check for updates

**Slack**:
- Auto-updates in background
- Manual check: Help → Check for Updates
- Or download latest installer from slack.com

Include these checks in your [monthly update routine](../configuration/periodic-updates.md).

---

## 🐛 Troubleshooting

### Office 365 Won't Activate

**Issue**: Office shows "Product activation required"

**Solutions**:
1. Ensure you're signed in with correct Microsoft account
2. File → Account → Sign in
3. Verify Office 365 subscription is active: [https://account.microsoft.com/services](https://account.microsoft.com/services)
4. Run Office activation troubleshooter
5. Repair Office: Settings → Apps → Microsoft Office → Advanced options → Repair

### Teams Won't Sign In

**Issue**: Cannot sign in to Teams

**Solutions**:
1. Check internet connection
2. Clear Teams cache:
   ```powershell
   # Close Teams first
   Remove-Item -Path "$env:APPDATA\Microsoft\Teams\*" -Recurse -Force
   ```
3. Restart Teams
4. Reinstall if necessary

### Slack Notifications Not Working

**Issue**: Not receiving Slack notifications

**Solutions**:
1. Check Windows notification settings: Settings → System → Notifications → Slack
2. Check Slack preferences: Preferences → Notifications
3. Check workspace-specific notification settings
4. Ensure Slack is running (not closed)
5. Check Do Not Disturb schedule isn't active

---

## 🔗 Related Documentation

- **Updates**: [Periodic Updates Guide](../configuration/periodic-updates.md)
- **Next Steps**: Continue with VPN and development tools installation

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Productivity and communication tools for client collaboration
