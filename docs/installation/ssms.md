# SQL Server Management Studio (SSMS) Installation

## 📋 Overview

SQL Server Management Studio (SSMS) is the primary tool for managing and developing SQL Server databases, including database design, query development, and server administration.

**Purpose**: Database management, query development, and administration  
**Supports**: SQL Server 2012 through SQL Server 2025  
**Free**: Yes, completely free from Microsoft

---

## 📥 Download SSMS

### Official Download Link

**SSMS Download Page**:
- Visit: [https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms](https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms)
- Or direct link: [https://aka.ms/ssmsfullsetup](https://aka.ms/ssmsfullsetup)

### Download Latest Version

1. **Click Download Link**
   - File: `SSMS-Setup-ENU.exe` (English version)
   - Size: ~600-700 MB
   - Version: Download latest stable release (check version number on download page)

2. **Save Installer**
   - Save to Downloads or preferred location
   - Keep installer for future reinstalls or updates

---

## 💾 Installation

### Prerequisites

- **Windows 11** ✅
- **.NET Framework 4.7.2 or later** (usually included with Windows 11)
- **Windows PowerShell** (included with Windows)
- **Approximately 2 GB free disk space**

### Installation Steps

1. **Run Installer**
   - Right-click `SSMS-Setup-ENU.exe`
   - Select **Run as administrator**
   - Click **Yes** on UAC prompt

2. **Welcome Screen**
   - SQL Server Management Studio Setup wizard launches
   - Click **Install** (express installation, recommended)
   - Or click **Customize** to change installation location

3. **Installation Options** (if Customize selected):
   - **Install location**: Default `C:\Program Files (x86)\Microsoft SQL Server Management Studio 20\` (version may vary)
   - Change if needed
   - Click **Install**

4. **Installation Progress**
   - Installer downloads and installs components
   - Duration: 10-20 minutes depending on internet speed
   - Progress bar shows installation status
   - Components installed:
     - SSMS application
     - Azure Data Studio (may be included)
     - SQL Server tools and libraries

5. **Setup Completed**
   - "Setup Completed Successfully" message
   - Optional: "Restart computer" (usually not required)
   - Click **Close**

---

## 🚀 First Launch and Configuration

### Launch SSMS

1. **Start SSMS**
   - Start Menu → Microsoft SQL Server Tools 20 → SQL Server Management Studio
   - Or: Search for "SSMS" in Start Menu

2. **Connect to SQL Server**
   - **Connect to Server** dialog appears automatically on first launch

### Connect to Local SQL Server

**Server Connection Settings**:

1. **Server type**: Database Engine

2. **Server name**: 
   - For local default instance: `localhost` or `.` or `(local)` or computer name
   - For named instance: `localhost\INSTANCENAME`
   - For MIRZAKHANI: `MIRZAKHANI` or `localhost`

3. **Authentication**: 
   - **Windows Authentication** (recommended for local development)
   - Or **SQL Server Authentication** (use `sa` account and password set during installation)

4. **Options** (optional):
   - Click **Options >>** for additional settings
   - **Connection Properties** tab:
     - Connect to database: `master` (default)
     - Network protocol: Default
     - Connection timeout: 15 seconds (default)

5. **Connect**:
   - Click **Connect**
   - SSMS connects to SQL Server
   - Object Explorer shows on left with server and databases

### Initial Configuration

1. **Object Explorer**
   - Expand server node to see:
     - Databases (system and user databases)
     - Security (logins, roles)
     - Server Objects
     - Replication
     - Management
     - Integration Services Catalogs
     - SQL Server Agent

2. **Configure Layout** (optional):
   - Tools → Options → Environment → General
   - Color theme: Blue (default), Dark, Light, or additional themes
   - Font and colors: Tools → Options → Environment → Fonts and Colors

3. **Configure Query Execution Defaults**:
   - Tools → Options → Query Execution → SQL Server → General
   - Default timeout settings
   - Execution options

---

## ⚙️ Essential SSMS Configuration

### Enable Line Numbers in Query Editor

```
Tools → Options → Text Editor → All Languages → General
☑ Line numbers
```

### Configure Auto-save

```
Tools → Options → Environment → AutoRecover
☑ Save AutoRecover information every: 5 minutes
☑ Keep AutoRecover information for: 7 days
```

### Configure IntelliSense

```
Tools → Options → Text Editor → Transact-SQL → IntelliSense
☑ Enable IntelliSense
```

### Set Default Database

Right-click server in Object Explorer → Properties → Connections → Default connection database

---

## 🔌 Connect to Analysis Services

SSMS can also connect to SQL Server Analysis Services (SSAS):

1. **File → Connect Object Explorer → Analysis Services**
   - Or: Click **Connect** icon in Object Explorer → Analysis Services

2. **Server name**: 
   - For local SSAS: `localhost` or computer name
   - Default port: 2383

3. **Authentication**: Windows Authentication

4. **Connect**
   - SSAS instance appears in Object Explorer
   - Expand to see SSAS databases and objects

---

## 🔌 Connect to Integration Services

Connect to SSIS:

1. **File → Connect Object Explorer → Integration Services**

2. **Server name**: `localhost` or `.`

3. **Connect**
   - Integration Services Catalogs appear in Object Explorer
   - Can manage SSIS packages and projects

---

## 📝 Useful SSMS Features

### Query Editor

- **New Query**: Click **New Query** button or `Ctrl+N`
- **Execute Query**: `F5` or click **Execute** button
- **Results to Grid/Text/File**: `Ctrl+D` / `Ctrl+T` / `Ctrl+Shift+F`
- **IntelliSense**: Auto-complete SQL code (`Ctrl+Space`)
- **Comment/Uncomment**: `Ctrl+K, Ctrl+C` / `Ctrl+K, Ctrl+U`

### Object Explorer

- **Refresh**: `F5` or right-click → Refresh
- **Object Explorer Details**: `F7` (shows details pane)
- **Filter objects**: Right-click object type → Filter → Filter Settings

### Templates

- **View → Template Explorer** or `Ctrl+Alt+T`
- Pre-built SQL templates for common tasks

### Registered Servers

- **View → Registered Servers** or `Ctrl+Alt+G`
- Register multiple servers for quick access

### Activity Monitor

- Right-click server in Object Explorer → **Activity Monitor**
- Monitor SQL Server performance and activity
- View processes, resource waits, data file I/O, recent queries

---

## 🔧 Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| New Query | `Ctrl+N` |
| Execute Query | `F5` or `Ctrl+E` |
| Results to Grid | `Ctrl+D` |
| Results to Text | `Ctrl+T` |
| IntelliSense | `Ctrl+Space` |
| Comment Selection | `Ctrl+K, Ctrl+C` |
| Uncomment Selection | `Ctrl+K, Ctrl+U` |
| Object Explorer | `F8` |
| Template Explorer | `Ctrl+Alt+T` |
| Registered Servers | `Ctrl+Alt+G` |
| Solution Explorer | `Ctrl+Alt+L` |
| Properties Window | `F4` |

---

## 🔄 Updates

### Check for SSMS Updates

SSMS does not auto-update. Check manually:

1. **Help → Check for Updates**
   - Opens web page with latest SSMS version
   - Compare with your installed version

2. **About Dialog**
   - Help → About
   - Shows installed version number

3. **Download and Install Updates**
   - Download latest SSMS installer from Microsoft
   - Run installer (automatically upgrades existing installation)
   - No uninstall needed

### Update Schedule

- **Microsoft releases SSMS updates monthly** (approximately)
- Include in [monthly update routine](../configuration/periodic-updates.md)
- Check: First week of each month

---

## ✅ Verification Checklist

- [ ] SSMS installed successfully
- [ ] Can launch SSMS without errors
- [ ] Connected to Database Engine (localhost)
- [ ] Object Explorer shows databases
- [ ] Can execute simple query (`SELECT @@VERSION`)
- [ ] Connected to Analysis Services
- [ ] Connected to Integration Services
- [ ] Query Editor configured (line numbers, IntelliSense)
- [ ] Template Explorer accessible
- [ ] Latest version installed

### Test Query

Run this query to verify connection:

```sql
-- Server information
SELECT 
    @@SERVERNAME AS ServerName,
    @@VERSION AS SQLVersion,
    SERVERPROPERTY('ProductVersion') AS Version,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('Edition') AS Edition;

-- List databases
SELECT name, database_id, create_date 
FROM sys.databases
ORDER BY name;
```

---

## 🐛 Troubleshooting

### Cannot Connect to SQL Server

**Issue**: "A network-related or instance-specific error occurred"

**Solutions**:
1. Verify SQL Server service is running:
   ```powershell
   Get-Service -Name MSSQLSERVER
   ```
2. Check server name is correct (use `localhost` for local instance)
3. Verify SQL Server is configured for TCP/IP (SQL Server Configuration Manager)
4. Check Windows Firewall if connecting remotely
5. Ensure SQL Server Browser service is running for named instances

### SSMS Crashes or Won't Launch

**Issue**: SSMS crashes on startup

**Solutions**:
1. Reset SSMS settings:
   ```cmd
   ssms.exe /ResetSettings
   ```
2. Clear SSMS cache:
   - Delete: `%AppData%\Microsoft\SQL Server Management Studio`
3. Repair installation: Rerun installer → Repair
4. Reinstall SSMS

### IntelliSense Not Working

**Issue**: Code auto-complete doesn't work

**Solutions**:
1. Enable IntelliSense: Tools → Options → Text Editor → Transact-SQL → IntelliSense
2. Refresh IntelliSense cache: `Ctrl+Shift+R` or Edit → IntelliSense → Refresh Local Cache
3. Ensure connected to database (IntelliSense requires connection)

---

## 🔗 Related Documentation

- **SQL Server Installation**: [SQL Server 2025](sql-server-2025.md)
- **Visual Studio**: [Visual Studio 2019](visual-studio-2019.md)
- **Azure Data Studio**: Alternative SQL tool (installed with SSMS)
- **Updates**: [Periodic Updates Guide](../configuration/periodic-updates.md)

---

## 📚 Additional Resources

- [SSMS Documentation](https://learn.microsoft.com/en-us/sql/ssms/sql-server-management-studio-ssms)
- [SSMS Keyboard Shortcuts](https://learn.microsoft.com/en-us/sql/ssms/sql-server-management-studio-keyboard-shortcuts)
- [SSMS Tips and Tricks](https://learn.microsoft.com/en-us/sql/ssms/tutorials/ssms-tricks)

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Primary database management and development tool
