# Additional Software Installation

This guide covers installation of additional productivity, utility, and personal software.

## Software Covered

1. **Bitwarden** - Password manager
2. **ComicShannsMono Nerd Font** - Programming font with icons
3. **Cyohash** - File hash/checksum calculator
4. **Garmin Express** - Garmin device management
5. **WhatsApp Desktop** - Messaging application
6. **MariaDB** - Open-source relational database
7. **Remote Desktop Manager Free** - Remote connection management

---

## 🔐 Bitwarden Password Manager

### Overview

Bitwarden is a free, open-source password manager for securely storing passwords, credentials, and sensitive information.

**Purpose**: Secure password storage and management  
**License**: Free (with optional premium features)

### Installation

#### Method 1: Microsoft Store (Recommended)

1. **Open Microsoft Store**
2. **Search**: "Bitwarden"
3. **Install**: Click **Get**
4. **Auto-updates** through Microsoft Store

#### Method 2: Direct Download

1. **Visit**: [https://bitwarden.com/download/](https://bitwarden.com/download/)
2. **Download**: Windows Desktop application
3. **Run installer**: `Bitwarden-Installer-[version].exe`
4. **Install**: Follow wizard (installs to `%LocalAppData%\Programs\Bitwarden`)

### Setup

1. **Launch Bitwarden**
2. **Create Account or Sign In**:
   - Create account: Requires email and master password
   - **Critical**: Remember master password (cannot be recovered!)
3. **Set up 2FA** (recommended):
   - Settings → Security → Two-step Login
   - Use authenticator app
4. **Install Browser Extension** (optional):
   - Chrome, Edge, Firefox extensions available
   - Integrates password autofill in browser

### Import Passwords

- Settings → Tools → Import Data
- Supports imports from Chrome, Firefox, LastPass, 1Password, etc.

### Verification

- [ ] Bitwarden installed and launches
- [ ] Account created or signed in
- [ ] Master password saved securely (written down offline)
- [ ] 2FA enabled (recommended)
- [ ] Browser extension installed (optional)

---

## 🔤 ComicShannsMono Nerd Font

### Overview

ComicShannsMono Nerd Font is a programming font that includes icons and symbols useful for development environments.

**Purpose**: Coding font with icon support for terminal, VS Code, etc.  
**Style**: Comic Sans-inspired monospace font with Nerd Font icons

### Download

1. **Visit Nerd Fonts**: [https://www.nerdfonts.com/](https://www.nerdfonts.com/)
2. **Downloads Page**: [https://www.nerdfonts.com/font-downloads](https://www.nerdfonts.com/font-downloads)
3. **Search**: "ComicShannsMono" or "Comic Mono"
4. **Download**: `ComicShannsMono.zip`

### Installation

1. **Extract ZIP file**
   - Right-click → Extract All
   - Extract to temporary folder

2. **Install Fonts**
   
   **Method 1: Install for Current User**
   - Select all `.ttf` or `.otf` files
   - Right-click → **Install for current user**
   - Fonts install to `%LocalAppData%\Microsoft\Windows\Fonts`

   **Method 2: Install for All Users** (requires admin)
   - Select all font files
   - Right-click → **Install for all users**
   - Fonts install to `C:\Windows\Fonts`

3. **Verify Installation**
   - Settings → Personalization → Fonts
   - Search for "ComicShannsMono"
   - Font should appear in list

### Configure in Applications

**VS Code**:
```json
// settings.json
{
    "editor.fontFamily": "'ComicShannsMono Nerd Font', Consolas, 'Courier New', monospace",
    "editor.fontSize": 14,
    "editor.fontLigatures": true
}
```

**Windows Terminal**:
```json
// settings.json, in profiles → defaults
{
    "font": {
        "face": "ComicShannsMono Nerd Font",
        "size": 11
    }
}
```

**PowerShell** (via $PROFILE):
```powershell
# Add to PowerShell profile if configuring console
# Most users use Windows Terminal instead
```

### Verification

- [ ] Font files downloaded and extracted
- [ ] Fonts installed (check Settings → Fonts)
- [ ] Font appears in VS Code font list
- [ ] Font appears in Terminal font list
- [ ] Icons render correctly in terminal prompts (if using Oh My Posh or similar)

---

## � Cyohash - File Hash Calculator

### Overview

Cyohash is a file hash/checksum calculator tool that integrates with Windows Explorer context menu for easy hash verification.

**Purpose**: Calculate MD5, SHA-1, SHA-256, SHA-512 checksums  
**License**: Free (open source)  
**Source**: [https://cyohash.sourceforge.net/](https://cyohash.sourceforge.net/)

### Installation

1. **Visit**: [https://sourceforge.net/projects/cyohash/](https://sourceforge.net/projects/cyohash/)
2. **Download**: Latest version (Windows installer)
3. **Run Installer**: `cyohash-[version]-setup.exe`
4. **Installation Wizard**:
   - Click **Next**
   - Accept license
   - Choose installation directory (default recommended)
   - **Select hash algorithms** to include in context menu:
     - ☑ MD5
     - ☑ SHA-1
     - ☑ SHA-256
     - ☑ SHA-512
   - Click **Install**
   - Click **Finish**

### Usage

**Calculate Hash via Context Menu**:
1. **Right-click** any file in Windows Explorer
2. **Select**: `CyoHash` → Choose algorithm (MD5, SHA-1, SHA-256, etc.)
3. **Hash displayed** in dialog window
4. **Copy to clipboard** button available

**Compare Hash**:
- Useful for verifying downloaded files against published checksums
- Compare calculated hash with expected hash from download page

### Verification

- [ ] Cyohash installed
- [ ] Context menu shows Cyohash option
- [ ] Can calculate MD5 hash of a test file
- [ ] Can calculate SHA-256 hash of a test file
- [ ] Hash result can be copied to clipboard

### Alternative: 7-Zip (Already Installed!)

**Good news**: 7-Zip (already installed via Ninite) includes hash calculation!

**How to use 7-Zip for hashes**:
1. **Right-click** any file
2. **7-Zip** → **CRC SHA** → Choose algorithm:
   - CRC-32
   - CRC-64
   - SHA-1
   - SHA-256
3. **Hash displayed** in window
4. Can calculate for multiple files at once

**Which to use?**
- **Cyohash**: Simpler, dedicated hash tool
- **7-Zip**: Already installed, supports multiple files, more algorithms

Both are excellent choices!

### Alternative: PowerShell (Built-in)

Windows PowerShell includes built-in hash calculation:

```powershell
# Calculate SHA-256 hash (default)
Get-FileHash C:\path\to\file.zip

# Calculate MD5 hash
Get-FileHash C:\path\to\file.zip -Algorithm MD5

# Calculate SHA-1 hash
Get-FileHash C:\path\to\file.zip -Algorithm SHA1

# Calculate SHA-512 hash
Get-FileHash C:\path\to\file.zip -Algorithm SHA512

# Copy hash to clipboard
(Get-FileHash C:\path\to\file.zip).Hash | Set-Clipboard
```

**Create PowerShell context menu** (advanced):
You can add a PowerShell script to context menu for quick hash calculation. This requires registry editing or third-party tools.

---

## ⌚ Garmin Express

### Overview

Garmin Express is used to update and sync Garmin GPS devices, fitness trackers, and smartwatches.

**Purpose**: Garmin device management, updates, and syncing  
**License**: Free

### Installation

1. **Visit**: [https://www.garmin.com/en-US/software/express](https://www.garmin.com/en-US/software/express)
2. **Download**: Garmin Express
3. **Run Installer**: `GarminExpress.exe`
4. **Install**: Follow wizard
5. **Launch**: Garmin Express opens automatically

### Setup

1. **Connect Garmin Device**
   - Plug device into USB port
   - Or pair via Bluetooth (for compatible devices)

2. **Add Device**
   - Garmin Express detects device
   - Click **Add a Device**
   - Follow prompts to register device

3. **Sync and Update**
   - Garmin Express shows available updates
   - Click **Install All** to update device
   - Sync activity data to Garmin Connect

### Verification

- [ ] Garmin Express installed
- [ ] Can detect connected Garmin device
- [ ] Device registered in Garmin Express
- [ ] Can check for software updates
- [ ] Can sync data to Garmin Connect

---

## 💬 WhatsApp Desktop

### Overview

WhatsApp Desktop application for Windows, synced with WhatsApp mobile app.

**Purpose**: Desktop messaging client for WhatsApp  
**Requirement**: WhatsApp account (requires phone number)

### Installation

#### Method 1: Microsoft Store (Recommended)

1. **Open Microsoft Store**
2. **Search**: "WhatsApp"
3. **Select**: WhatsApp (by WhatsApp LLC)
4. **Install**: Click **Get**
5. **Auto-updates** through Microsoft Store

#### Method 2: Direct Download

1. **Visit**: [https://www.whatsapp.com/download](https://www.whatsapp.com/download)
2. **Download**: WhatsApp for Windows
3. **Run Installer**: `WhatsAppSetup.exe`
4. **Install**: Automatic installation

### Setup

1. **Launch WhatsApp Desktop**
2. **Scan QR Code**:
   - Open WhatsApp on phone
   - Tap Menu (⋮) or Settings → Linked Devices
   - Tap **Link a Device**
   - Scan QR code shown on desktop app

3. **Desktop App Syncs**
   - Chats sync from phone
   - Can send/receive messages on desktop

### Tips

- **Notifications**: Configure in Settings → Notifications
- **Keep phone connected**: Phone must have internet for WhatsApp Desktop to work
- **Calls**: WhatsApp Desktop supports voice and video calls

### Verification

- [ ] WhatsApp Desktop installed
- [ ] QR code scanned and linked to phone
- [ ] Chats synced from phone
- [ ] Can send and receive messages
- [ ] Notifications working

---

## 🗄️ MariaDB Database Server

### Overview

MariaDB is a community-developed, open-source relational database, fork of MySQL.

**Purpose**: Open-source database server  
**License**: Free (GPL)  
**Use Case**: Alternative to MySQL, compatible with MySQL clients

### Installation

1. **Visit**: [https://mariadb.org/download/](https://mariadb.org/download/)
2. **Select Version**: Latest stable version
3. **Operating System**: Windows
4. **Download**: MSI installer (64-bit)

5. **Run Installer**: `mariadb-[version]-winx64.msi`
6. **Installation Wizard**:
   - Click **Next**
   - Accept license
   - Click **Next**
   - **Custom Setup**: Select components (default is fine)
     - Database instance
     - Client programs
     - Development components (optional)
   - Click **Next**
   - **Root Password**: Set strong password for `root` account
     - **Save securely** (use Bitwarden!)
     - Confirm password
   - **Enable networking**: Check (default port 3306)
   - **Create Windows service**: Check (Auto-start recommended)
   - **Character set**: UTF-8 (utf8mb4 recommended)
   - Click **Next**
   - **Install**
   - Click **Finish**

### Post-Installation

1. **Verify Service Running**
   ```powershell
   Get-Service -Name MySQL  # Note: Service may be named "MySQL" even though it's MariaDB
   # Or
   Get-Service -Name MariaDB
   ```

2. **Test Connection**
   ```cmd
   # Using MariaDB client (installed with MariaDB)
   mysql -u root -p
   # Enter root password
   # Should connect to MariaDB prompt: MariaDB [(none)]>
   ```

3. **Create Test Database** (optional)
   ```sql
   CREATE DATABASE test_db;
   SHOW DATABASES;
   EXIT;
   ```

### Configure Firewall (if remote access needed)

```powershell
New-NetFirewallRule -DisplayName "MariaDB" -Direction Inbound -Protocol TCP -LocalPort 3306 -Action Allow
```

### Connect from External Tools

**DBeaver** (already installed):
1. New Connection → MariaDB (or MySQL)
2. Host: `localhost`
3. Port: `3306`
4. Database: (leave blank or specify)
5. Username: `root`
6. Password: [your root password]
7. Test Connection → OK

**Connection String Examples**:
```
# ADO.NET
Server=localhost;Port=3306;Database=mydb;Uid=root;Pwd=password;

# ODBC
DRIVER={MariaDB ODBC 3.1 Driver};SERVER=localhost;PORT=3306;DATABASE=mydb;UID=root;PWD=password;
```

### Verification

- [ ] MariaDB installed
- [ ] Service running
- [ ] Can connect via mysql client with root password
- [ ] Can create databases
- [ ] DBeaver can connect to MariaDB
- [ ] Root password saved securely

---

## 🖥️ Remote Desktop Manager Free Edition

### Overview

Remote Desktop Manager Free is a tool for managing remote connections (RDP, SSH, VNC, etc.) in one centralized application.

**Purpose**: Centralized remote connection management  
**Edition**: Free (limited features vs. paid editions)  
**License**: Free for personal/small team use

### Installation

1. **Visit**: [https://devolutions.net/remote-desktop-manager/home/download](https://devolutions.net/remote-desktop-manager/home/download)
2. **Select**: Remote Desktop Manager Free
3. **Download**: Windows installer
4. **Run Installer**: `Setup.RemoteDesktopManagerFree.exe`
5. **Installation Wizard**:
   - Click **Next**
   - Accept license
   - Select installation type: **Typical** (recommended)
   - Click **Install**
   - Click **Finish**

### First Launch

1. **Launch Remote Desktop Manager**
2. **Choose Data Source**:
   - **SQLite** (recommended for single user, local storage)
   - **XML** (portable, file-based)
   - Or connect to existing data source
3. **Create Data Source**:
   - File → Data Sources → Add Data Source
   - Select type (SQLite for local)
   - Set name and location
   - Click **OK**

### Add Remote Connections

**Add RDP Connection**:
1. **New Entry** → **Session** → **RDP (Microsoft Remote Desktop)**
2. **Connection settings**:
   - Name: Descriptive name
   - Host: IP or hostname
   - Username: (optional, can prompt)
   - Domain: (if domain-joined remote machine)
3. **Save**

**Add SSH Connection**:
1. **New Entry** → **Session** → **SSH Shell**
2. **Connection settings**:
   - Name: Descriptive name
   - Host: IP or hostname
   - Port: 22 (default)
   - Username
   - Authentication: Password or Key
3. **Save**

**Add VPN Connection**:
1. **New Entry** → **Session** → **VPN**
2. Configure VPN parameters

### Organize Connections

- Create **folders** for organizing connections by client, environment, type
- **Tags** for easy filtering
- **Groups** for bulk operations

### Verification

- [ ] Remote Desktop Manager Free installed
- [ ] Data source created (SQLite or XML)
- [ ] Can add RDP session
- [ ] Can add SSH session
- [ ] Can organize sessions in folders
- [ ] Can connect to remote machine (if test available)

---

## 📋 Summary Checklist

- [ ] **Bitwarden**: Installed, account created, 2FA enabled
- [ ] **ComicShannsMono Nerd Font**: Fonts installed, configured in VS Code/Terminal
- [ ] **Cyohash**: Installed, context menu integration working (or using 7-Zip/PowerShell alternative)
- [ ] **Garmin Express**: Installed, Garmin device synced
- [ ] **WhatsApp Desktop**: Installed, linked to phone
- [ ] **MariaDB**: Installed, service running, root password set
- [ ] **Remote Desktop Manager Free**: Installed, data source created

---

## 🔗 Related Documentation

- **Password Security**: Use Bitwarden for storing all software passwords (SQL Server, MariaDB, etc.)
- **Database Tools**: [DBeaver](additional-dev-tools.md) for MariaDB connection
- **Updates**: [Periodic Updates Guide](../configuration/periodic-updates.md)

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Additional productivity, utility, and personal software
