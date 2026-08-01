# SQL Server 2025 Installation & Configuration

## 📋 Overview

This guide covers the installation of Microsoft SQL Server 2025 with the following components:
- **Database Engine** - Default instance
- **Analysis Services (Tabular)** - For SSAS Tabular models
- **Integration Services** - For SSIS packages

After installation, we'll apply the latest Cumulative Update for security and stability.

**Edition**: Developer Edition (recommended for development) or Standard/Enterprise (if licensed)  
**Instance**: Default instance (MSSQLSERVER)  
**Authentication**: Mixed Mode (Windows + SQL Server)

---

## 📥 Download SQL Server 2025

### Download Links

**SQL Server 2025 Developer Edition** (Free):
- Visit: [https://www.microsoft.com/en-us/sql-server/sql-server-downloads](https://www.microsoft.com/en-us/sql-server/sql-server-downloads)
- Click **Download now** under Developer Edition
- File: `SQL2025-SSEI-Dev.exe` (web installer)

**SQL Server 2025 Evaluation Edition** (180-day trial):
- Same download page
- Useful for testing Enterprise features

**Licensed Editions** (Standard/Enterprise):
- Download from Volume Licensing Service Center or Microsoft Account
- Or use evaluation and enter license key during/after installation

---

## 💾 Pre-Installation Requirements

### System Requirements

- **OS**: Windows 11 (64-bit) ✅
- **RAM**: Minimum 4 GB, Recommended 16+ GB (32 GB on MIRZAKHANI ✅)
- **Disk Space**: Minimum 6 GB, Recommended 10+ GB
- **Processor**: x64 compatible, 1.4 GHz minimum

### Prerequisites

1. **Install .NET Framework 4.8 or later**
   ```powershell
   # Check installed .NET versions
   Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name version -EA 0 | Where { $_.PSChildName -Match '^(?!S)\p{L}'} | Select PSChildName, version
   ```
   - Windows 11 typically includes .NET 4.8+
   - If needed: Download from Microsoft

2. **Windows Updates**
   - Ensure all Windows updates are installed
   - Settings → Windows Update

3. **Sufficient Disk Space**
   ```powershell
   Get-PSDrive C | Select-Object Used,Free,@{Name="Capacity(GB)";Expression={$_.Used+$_.Free}}
   ```

4. **Administrator Rights**
   - SQL Server installation requires administrator privileges

---

## 🔧 Installation Process

### Step 1: Run SQL Server Installer

1. **Launch Installer**
   - Run downloaded `SQL2025-SSEI-Dev.exe` (web installer)
   - Or if you have ISO: Mount ISO and run `Setup.exe`

2. **Choose Installation Type**
   - Select **Basic**, **Custom**, or **Download Media**
   - **Recommended**: Choose **Custom** for full control
   - If Custom: Choose download location for installation files

3. **Download Installation Files**
   - Installer downloads required files (~2-3 GB)
   - Wait for download to complete

### Step 2: SQL Server Installation Center

After files download, SQL Server Installation Center launches:

1. **Select Installation**
   - Left menu: **Installation**
   - Click **New SQL Server stand-alone installation or add features to an existing installation**

### Step 3: Product Key

- **Developer Edition**: No key required, automatically selected
- **Evaluation**: Automatically selected (180-day trial)
- **Licensed Edition**: Enter product key

Click **Next**

### Step 4: License Terms

- Accept license terms
- Check "I accept the license terms"
- **Optional**: Check "Send usage information to Microsoft" (or uncheck)
- Click **Next**

### Step 5: Microsoft Update

- **Recommended**: Check "Use Microsoft Update to check for updates"
- Helps keep SQL Server secure and up-to-date
- Click **Next**

### Step 6: Install Setup Files

- Installer checks rules and installs setup support files
- Wait for completion
- Click **Next**

### Step 7: Install Rules

- Setup checks for potential issues
- Review any warnings (yellow icons)
- Failures (red X) must be resolved before continuing
- Common warnings can usually be ignored:
  - Windows Firewall warning (we'll configure later)
- Click **Next**

### Step 8: Feature Selection

**Select the following features**:

✅ **Database Engine Services**
   - Core SQL Server database engine
   - Default instance

✅ **Analysis Services**
   - Select this for SSAS
   - We'll configure for Tabular mode later

✅ **Integration Services**
   - For SSIS package development and execution

**Optional but Recommended**:
- ✅ **Client Tools Connectivity** (automatically selected with above)
- ✅ **Management Tools – Complete** (if available here, otherwise install SSMS separately)

**Instance Features**:
- Database Engine Services
- Analysis Services
- Integration Services

**Shared Features** (automatically selected as needed):
- Client Tools Connectivity
- Client Tools Backwards Compatibility (optional)

**Installation Directories**:
- Instance root directory: Default `C:\Program Files\Microsoft SQL Server\`
- Shared feature directory: Default (recommended)

Click **Next**

### Step 9: Instance Configuration

1. **Instance Configuration**
   - Select **Default instance**
   - Instance ID: `MSSQLSERVER`
   - Instance root directory: Default

2. **Installed Instances**
   - Shows if any existing instances
   - For fresh install, should be empty

Click **Next**

### Step 10: Server Configuration

**Service Accounts**:

Configure service accounts for each service:

1. **SQL Server Database Engine**
   - Account Name: `NT Service\MSSQLSERVER` (recommended, virtual account)
   - Or use `NT AUTHORITY\SYSTEM` or domain account if domain-joined
   - Startup Type: **Automatic**

2. **SQL Server Analysis Services**
   - Account Name: `NT Service\MSSQLServerOLAPService` (recommended)
   - Startup Type: **Automatic**

3. **SQL Server Integration Services 16.0** (version may vary)
   - Account Name: `NT Service\MsDtsServer160` (recommended)
   - Startup Type: **Automatic**

**Collation**: 
- Click **Collation** tab
- Database Engine: Default `SQL_Latin1_General_CP1_CI_AS` (recommended)
- Analysis Services: Default collation
- Only change if specific collation required by client

Click **Next**

### Step 11: Database Engine Configuration

**Server Configuration** tab:

1. **Authentication Mode**:
   - Select **Mixed Mode (SQL Server authentication and Windows authentication)**
   - This allows both Windows and SQL logins
   
2. **Enter SQL Server Administrator Password**:
   - Set strong password for `sa` account
   - **Important**: Save this password securely (use password manager)
   - Confirm password
   - **Security**: Store sa password securely, NOT in Git

3. **Specify SQL Server Administrators**:
   - Click **Add Current User** to add your Windows account as admin
   - **Recommended**: Add current Windows user
   - If domain-joined: Add domain account
   - Can add additional Windows users/groups if needed

**Data Directories** tab (optional):
- Default locations:
  - Data root directory: `C:\Program Files\Microsoft SQL Server\`
  - User database directory: `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\`
  - User database log directory: Same as data
  - Backup directory: `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\`
- **Change if needed**: E.g., if you have separate data drive
- **Development**: Defaults are usually fine

**TempDB** tab (optional):
- Number of files: Auto-configured based on CPU cores
- Initial size: 8 MB default (auto-grows)
- File growth: 64 MB increments
- **Development**: Defaults are usually fine

**MaxDOP** tab (optional):
- Maximum Degree of Parallelism
- Default configuration (recommended for development)

**Memory** tab (optional):
- SQL Server memory limits
- Default: SQL Server manages automatically
- **Can configure later** based on workload

Click **Next**

### Step 12: Analysis Services Configuration

1. **Server Mode**:
   - Select **Tabular Mode** ✅
   - (Other options: Multidimensional and Data Mining Mode, PowerPivot Mode)

2. **Analysis Services Administrators**:
   - Click **Add Current User**
   - Adds your Windows account as SSAS admin
   - Can add additional users/groups

3. **Data Directories** (optional):
   - Default locations usually fine for development
   - Change if you have specific requirements

Click **Next**

### Step 13: Ready to Install

1. **Review Configuration Summary**
   - Review all selected features and settings
   - Verify:
     - Database Engine, Analysis Services, Integration Services selected
     - Default instance
     - Mixed mode authentication
     - Tabular mode for SSAS
     - Current user added as administrator

2. **Configuration File**
   - Click **Install** to begin
   - Installation begins

### Step 14: Installation Progress

- Installation proceeds through all selected components
- Duration: 15-45 minutes depending on features
- **Do not interrupt installation**
- Watch for any errors (rare)

### Step 15: Complete

- Installation complete screen shows status
- All features should show "Success" with green checkmarks
- Review any warnings or errors
- Click **Close**

---

## ✅ Post-Installation Verification

### Verify Services are Running

```powershell
# Check SQL Server services
Get-Service -Name MSSQLSERVER  # Database Engine
Get-Service -Name MSSQLServerOLAPService  # Analysis Services
Get-Service -Name MsDtsServer160  # Integration Services (version may vary)

# Or check all SQL Server services
Get-Service -DisplayName "*SQL Server*"
```

All services should show `Status: Running`

### Test Database Engine Connection

```powershell
# Test local connection
sqlcmd -S localhost -E
# Should connect and show: 1>

# At sqlcmd prompt:
SELECT @@VERSION;
GO
# Should show SQL Server 2025 version

# Exit sqlcmd:
EXIT
```

### Check SQL Server Version

```sql
-- In SSMS or sqlcmd:
SELECT @@VERSION;
SELECT SERVERPROPERTY('ProductVersion') AS Version,
       SERVERPROPERTY('ProductLevel') AS ProductLevel,
       SERVERPROPERTY('Edition') AS Edition;
```

### Verify Analysis Services

```powershell
# Test SSAS connection (using PowerShell with SSAS cmdlets if available)
# Or connect via SSMS to localhost (Analysis Services)
```

---

## 🔄 Apply Latest Cumulative Update

**Important**: Always apply the latest Cumulative Update (CU) for security patches and bug fixes.

### Check for Latest CU

1. **Find Latest CU**:
   - Visit: [SQL Server 2025 Build Versions](https://learn.microsoft.com/en-us/troubleshoot/sql/releases/download-and-install-latest-updates)
   - Or search: "SQL Server 2025 latest cumulative update"
   - Note the latest CU number (e.g., CU1, CU2, etc.)

2. **Download CU**:
   - Download from Microsoft Download Center
   - File typically: `SQLServer2025-KB#######-x64.exe`

### Install Cumulative Update

1. **Close all SQL Server-related applications**:
   - Close SSMS, Azure Data Studio, Visual Studio
   - Ensure no active connections to SQL Server

2. **Run CU Installer**:
   - Run downloaded `.exe` as administrator
   - Click **Yes** on UAC prompt

3. **Select Instance**:
   - Select **MSSQLSERVER** (default instance)
   - Select all features to update:
     - Database Engine
     - Analysis Services
     - Integration Services
     - Shared components

4. **Accept License Terms**:
   - Review and accept
   - Click **Next**

5. **Check Rules**:
   - Setup checks for issues
   - Resolve any blocking issues
   - Click **Next**

6. **Select Features**:
   - All applicable features should be selected
   - Verify Database Engine, Analysis Services, Integration Services
   - Click **Next**

7. **Ready to Update**:
   - Review summary
   - Click **Update**

8. **Update Progress**:
   - Wait for update to complete (10-20 minutes)
   - Services will be stopped and restarted automatically

9. **Complete**:
   - All features should show "Success"
   - Click **Close**

10. **Restart Services** (if needed):
    ```powershell
    Restart-Service -Name MSSQLSERVER -Force
    Restart-Service -Name MSSQLServerOLAPService -Force
    Restart-Service -Name MsDtsServer160 -Force
    ```

### Verify CU Installation

```sql
-- Check updated version
SELECT @@VERSION;
-- Should show new build number

SELECT SERVERPROPERTY('ProductVersion') AS Version,
       SERVERPROPERTY('ProductLevel') AS ProductLevel,
       SERVERPROPERTY('ProductUpdateLevel') AS CU;
```

---

## 🔥 Configure Windows Firewall

Allow SQL Server through Windows Firewall:

```powershell
# Allow Database Engine (default port 1433)
New-NetFirewallRule -DisplayName "SQL Server Database Engine" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow

# Allow Analysis Services (default port 2383)
New-NetFirewallRule -DisplayName "SQL Server Analysis Services" -Direction Inbound -Protocol TCP -LocalPort 2383 -Action Allow

# Or use SQL Server Configuration Manager to configure
```

**Note**: Only configure firewall rules if you need remote access. For local development, not strictly necessary.

---

## ⚙️ Post-Installation Configuration

### Enable SQL Server Browser (Optional)

If you plan to have named instances or need browser service:

```powershell
# Set SQL Server Browser to Automatic and start
Set-Service -Name SQLBrowser -StartupType Automatic
Start-Service -Name SQLBrowser
```

### Configure SQL Server for Remote Connections

```sql
-- Enable remote connections (using SSMS or sqlcmd)
EXEC sys.sp_configure N'remote access', N'1';
GO
RECONFIGURE WITH OVERRIDE;
GO
```

### Enable TCP/IP Protocol

1. **Open SQL Server Configuration Manager**:
   - Start Menu → Microsoft SQL Server 2025 → SQL Server Configuration Manager
   - Or: Run `SQLServerManager16.msc` (version number may vary)

2. **Enable TCP/IP**:
   - Expand **SQL Server Network Configuration**
   - Click **Protocols for MSSQLSERVER**
   - Right-click **TCP/IP** → **Enable**
   - Click **OK** on warning that services must be restarted

3. **Restart SQL Server**:
   ```powershell
   Restart-Service -Name MSSQLSERVER
   ```

### Configure Maximum Memory (Recommended)

Prevent SQL Server from using all available RAM:

```sql
-- Reserve some RAM for OS and other apps
-- On 32 GB system, allocate 24 GB to SQL Server (leave 8 GB for OS)
EXEC sys.sp_configure N'max server memory (MB)', N'24576';  -- 24 GB
GO
RECONFIGURE WITH OVERRIDE;
GO
```

---

## 📋 Installation Checklist

- [ ] SQL Server 2025 downloaded
- [ ] Prerequisites met (.NET Framework, Windows updates)
- [ ] SQL Server installed with Database Engine, Analysis Services (Tabular), Integration Services
- [ ] Default instance (MSSQLSERVER)
- [ ] Mixed mode authentication configured
- [ ] sa password saved securely
- [ ] Current user added as administrator
- [ ] All services running
- [ ] Can connect to Database Engine via sqlcmd or SSMS
- [ ] Latest Cumulative Update applied
- [ ] Updated version verified
- [ ] Firewall configured (if needed for remote access)
- [ ] TCP/IP protocol enabled
- [ ] Maximum memory configured

---

## 🔗 Related Documentation

- **SSMS Installation**: [SQL Server Management Studio](ssms.md)
- **Visual Studio**: [Visual Studio 2019 with Data Workload](visual-studio-2019.md)
- **Power BI Report Server**: [Power BI Report Server Installation](power-bi-report-server.md)
- **Updates**: [Periodic Updates Guide](../configuration/periodic-updates.md)

---

## 📚 Additional Resources

- [SQL Server 2025 Documentation](https://learn.microsoft.com/en-us/sql/sql-server/)
- [SQL Server Installation Guide](https://learn.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server)
- [SQL Server 2025 Cumulative Updates](https://learn.microsoft.com/en-us/troubleshoot/sql/releases/download-and-install-latest-updates)
- [SQL Server Configuration Manager](https://learn.microsoft.com/en-us/sql/relational-databases/sql-server-configuration-manager)

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Core database platform for BI development
**Instance**: MSSQLSERVER (default)  
**Components**: Database Engine, Analysis Services (Tabular), Integration Services
