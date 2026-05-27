# Power BI Report Server Installation

## 📋 Overview

Power BI Report Server is an on-premises report server with a web portal for displaying and managing Power BI reports, paginated reports (RDL), mobile reports, and KPIs.

**Purpose**: On-premises Power BI and SSRS reporting platform  
**License**: Requires SQL Server Enterprise with Software Assurance, Power BI Premium, or evaluation license  
**Components**: Report Server, Web Portal, Power BI Desktop for Report Server

---

## 📥 Download Power BI Report Server

### Official Download Links

**Power BI Report Server**:
- Visit: [https://powerbi.microsoft.com/report-server/](https://powerbi.microsoft.com/report-server/)
- Click **Download free trial** or **Download now**
- Or: [https://www.microsoft.com/en-us/download/details.aspx?id=56722](https://www.microsoft.com/en-us/download/details.aspx?id=56722)

**Downloads Include**:
1. **Power BI Report Server installer** (`PowerBIReportServer.exe`)
2. **Power BI Desktop for Report Server** (separate from regular Power BI Desktop)
3. **Product key** (for evaluation or licensed version)

### Download Components

1. **Power BI Report Server**
   - File: `PowerBIReportServer.exe`
   - Size: ~500 MB

2. **Power BI Desktop (Report Server Edition)**
   - Different from standard Power BI Desktop
   - Optimized for Power BI Report Server
   - File: `PBIDesktopRS.msi`
   - Size: ~600 MB

3. **Product Key**
   - Evaluation: 180-day trial key provided on download page
   - Licensed: Use key from Volume Licensing or Power BI Premium
   - Copy and save product key

---

## 💾 Prerequisites

### System Requirements

- **Operating System**: Windows 11 ✅ or Windows Server 2019+
- **RAM**: Minimum 4 GB, Recommended 8+ GB (32 GB ✅)
- **Disk Space**: Minimum 1 GB for application, additional for report storage
- **SQL Server Database Engine**: Required for Report Server databases
  - SQL Server 2016 or later ✅ (SQL Server 2025 already installed)
  - Can use existing SQL Server instance

### Required SQL Server Components

Ensure SQL Server is installed with:
- ✅ Database Engine (already installed)
- Service running and accessible

### Prerequisites Checklist

- [ ] SQL Server 2025 installed and running
- [ ] Can connect to SQL Server Database Engine
- [ ] .NET Framework 4.8 or later (included with Windows 11)
- [ ] Administrator rights for installation
- [ ] Product key available (evaluation or licensed)

---

## 🔧 Installation Process

### Step 1: Run Power BI Report Server Installer

1. **Launch Installer**
   - Run `PowerBIReportServer.exe`
   - Click **Yes** on UAC prompt

2. **Welcome Screen**
   - Click **Next**

### Step 2: License Terms

1. **Read License Agreement**
   - Accept license terms
   - Click **Next**

### Step 3: Product Key

1. **Enter Product Key**
   - **Evaluation edition**: Use evaluation key from download page
   - **Licensed edition**: Enter your product key
   - Click **Next**

### Step 4: Installation Type

Choose installation type:

1. **Install Power BI Report Server** (Recommended for first installation)
   - Full installation with configuration
   - We'll choose this option

2. **Install only** 
   - Installs files but doesn't configure
   - Use if configuring later or for upgrade

**Select**: Install Power BI Report Server  
Click **Next**

### Step 5: Feature Selection

Select features to install:

✅ **Report Server**
   - Core report server engine
   - Required

✅ **Web Portal**
   - Browser-based report management interface
   - Required

**Installation folder**:
- Default: `C:\Program Files\Microsoft Power BI Report Server\`
- Change if needed

Click **Next**

### Step 6: Report Server Configuration

**Database Configuration**:

1. **Database Server**
   - Server name: `localhost` or `MIRZAKHANI` (your SQL Server instance)
   - Authentication: **Windows Authentication** (recommended)
   - Click **Next**

2. **Database Name**
   - Creates two databases:
     - `ReportServer` - Report server database
     - `ReportServerTempDB` - Temporary database
   - Default names recommended
   - Or specify custom names
   - Click **Next**

3. **Service Account**
   - **Network Service** (recommended for local development)
   - Or **Virtual Account** or **Domain Account** (for production)
   - Default: Network Service
   - Click **Next**

4. **Web Service URL**
   - **Virtual Directory**: `ReportServer` (default)
   - URL will be: `http://localhost/ReportServer`
   - Port: Default (80) or specify custom port if 80 is in use
   - Click **Next**

5. **Web Portal URL**
   - **Virtual Directory**: `Reports` (default)
   - URL will be: `http://localhost/Reports`
   - Click **Next**

### Step 7: Ready to Install

1. **Review Configuration Summary**
   - Verify all settings
   - Database server
   - Service account
   - URLs

2. **Click Install**
   - Installation begins

### Step 8: Installation Progress

- Installation proceeds through all components
- Creates databases in SQL Server
- Configures web services
- Duration: 10-20 minutes

### Step 9: Complete

- Installation complete screen
- Shows Report Server URL and Web Portal URL
- Click **Finish**

---

## 🌐 Verify Installation

### Access Web Portal

1. **Open Web Browser**
   - Navigate to: `http://localhost/Reports`
   - Or: `http://MIRZAKHANI/Reports`

2. **Web Portal Loads**
   - Should see Power BI Report Server web portal
   - Shows folders: Home
   - Can browse and upload reports

### Verify Report Server URL

1. **Navigate to Report Server**
   - `http://localhost/ReportServer`
   - Shows directory listing (XML format)
   - This is the web service endpoint

### Check SQL Server Databases

```sql
-- In SSMS, verify Report Server databases were created
SELECT name FROM sys.databases 
WHERE name LIKE 'ReportServer%';

-- Should return:
-- ReportServer
-- ReportServerTempDB
```

---

## 💻 Install Power BI Desktop (Report Server Edition)

### Important: Separate Version Required

Power BI Desktop for Report Server is **different** from standard Power BI Desktop:
- Optimized for Power BI Report Server
- Different release cycle
- Can be installed alongside standard Power BI Desktop

### Installation Steps

1. **Run Installer**
   - Run downloaded `PBIDesktopRS.msi`
   - Click **Next**

2. **License Agreement**
   - Accept terms
   - Click **Next**

3. **Destination Folder**
   - Default: `C:\Program Files\Microsoft Power BI Desktop RS\`
   - Note: Different folder from standard Power BI Desktop
   - Click **Next**

4. **Ready to Install**
   - Click **Install**
   - Installation completes (5-10 minutes)

5. **Complete**
   - Click **Finish**

### Launch Power BI Desktop (Report Server)

1. **Start Application**
   - Start Menu → Microsoft Power BI Desktop (Report Server)
   - Distinct from "Microsoft Power BI Desktop" if you have both

2. **Sign In** (optional)
   - Sign in with Microsoft account
   - Or skip

3. **Verify Version**
   - File → Help → About
   - Should show "Power BI Desktop (Report Server)"
   - Shows version date (e.g., "May 2026")

---

## 📤 Publish Reports to Report Server

### Publish from Power BI Desktop

1. **Create or Open Report** in Power BI Desktop (Report Server edition)

2. **Publish**
   - File → Publish → Publish to Power BI Report Server
   - Or: **Publish** button in Home ribbon

3. **Report Server URL**
   - Enter: `http://localhost/Reports`
   - Or: `http://MIRZAKHANI/Reports`

4. **Select Folder**
   - Choose destination folder in web portal
   - Or create new folder

5. **Publish**
   - Click **Select**
   - Report uploads to server
   - Success message with link to report

6. **View Report**
   - Click link or navigate to web portal
   - Report appears and can be viewed/shared

---

## ⚙️ Configuration and Management

### Report Server Configuration Manager

For advanced configuration:

1. **Launch Configuration Manager**
   - Start Menu → Microsoft Power BI Report Server → Report Server Configuration Manager
   - Or: Search for "Report Server Configuration Manager"

2. **Connect to Report Server**
   - Server name: `localhost`
   - Report Server Instance: `PBIRS` (default)
   - Click **Connect**

3. **Configuration Options**:
   - **Service Account**: Change service account
   - **Web Service URL**: Modify URL or add additional URLs
   - **Database**: Change database or connection
   - **Web Portal URL**: Modify web portal URL
   - **Email Settings**: Configure SMTP for subscriptions
   - **Execution Account**: Set unattended execution account
   - **Encryption Keys**: Backup/restore encryption keys
   - **Subscription Settings**: Configure data-driven subscriptions
   - **Scale-Out Deployment**: Add servers to scale-out (enterprise)

### Backup Encryption Keys

**Important**: Backup encryption keys before system changes:

1. **Report Server Configuration Manager**
   - Connect to report server
   - Click **Encryption Keys** in left pane

2. **Backup**
   - Click **Backup**
   - Choose location and filename (e.g., `ReportServer_EncryptionKey.snk`)
   - Enter password to protect key file
   - Click **OK**

3. **Store Securely**
   - Save key file to secure location (NOT in Git!)
   - Store password in password manager
   - Required to restore report server or migrate

---

## 🔒 Security Configuration

### Configure Permissions

1. **Access Web Portal**: `http://localhost/Reports`

2. **Site Settings** (gear icon in upper right)

3. **Security**
   - Configure folder-level security
   - Add users/groups
   - Assign roles:
     - **Content Manager**: Full permissions
     - **Publisher**: Can publish reports
     - **Browser**: Can view reports
     - **Report Builder**: Can create Report Builder reports
     - **My Reports**: Personal folder access

4. **Add User/Group**
   - Click **New Role Assignment**
   - Enter Windows user or group (e.g., `MIRZAKHANI\user1729` or domain account)
   - Select role
   - Click **OK**

---

## 🔄 Updates and Maintenance

### Check for Updates

Power BI Report Server updates quarterly:

1. **Check Current Version**
   - Web Portal → Settings (gear icon) → About
   - Shows installed version and build

2. **Download Updates**
   - Visit: [https://powerbi.microsoft.com/report-server/](https://powerbi.microsoft.com/report-server/)
   - Check for newer version
   - Download latest installer

3. **Apply Update**
   - Run installer (same `PowerBIReportServer.exe`)
   - Automatically detects existing installation
   - Upgrades in place
   - **Important**: Backup encryption keys first!

### Update Schedule

- **Quarterly**: Microsoft releases Power BI Report Server updates
- Align with Power BI Desktop (Report Server edition) updates
- Include in [periodic updates guide](../configuration/periodic-updates.md)

### Update Power BI Desktop (Report Server)

- Download latest version from Power BI Report Server download page
- Run installer (upgrades existing installation)
- Must match or be compatible with Report Server version

---

## ✅ Verification Checklist

- [ ] Power BI Report Server installed
- [ ] ReportServer and ReportServerTempDB databases created in SQL Server
- [ ] Web Portal accessible at `http://localhost/Reports`
- [ ] Report Server web service accessible at `http://localhost/ReportServer`
- [ ] Power BI Desktop (Report Server edition) installed
- [ ] Can publish test report to Report Server
- [ ] Can view published report in web portal
- [ ] Encryption keys backed up to secure location
- [ ] User permissions configured
- [ ] Latest version installed

---

## 🐛 Troubleshooting

### Cannot Access Web Portal

**Issue**: `http://localhost/Reports` not accessible

**Solutions**:
1. Verify Report Server service is running:
   ```powershell
   Get-Service -Name "Power BI Report Server"
   ```
2. Check URL in Report Server Configuration Manager
3. Try computer name instead of localhost
4. Check Windows Firewall settings
5. Verify IIS is not blocking port 80

### Database Creation Failed

**Issue**: Report Server databases not created during installation

**Solutions**:
1. Verify SQL Server is running and accessible
2. Ensure Windows account has permissions to create databases
3. Use Report Server Configuration Manager to manually configure database
4. Check SQL Server error logs for details

### Cannot Publish Reports

**Issue**: Publishing from Power BI Desktop fails

**Solutions**:
1. Verify using Power BI Desktop (Report Server edition), not standard version
2. Check Report Server URL is correct
3. Ensure you have Publisher or Content Manager role
4. Verify network connectivity to report server
5. Check Report Server service is running

### Encryption Key Issues

**Issue**: After restore, reports show encryption errors

**Solutions**:
1. Restore encryption keys from backup
2. Report Server Configuration Manager → Encryption Keys → Restore
3. Select backup file and enter password
4. Restart Report Server service

---

## 🔗 Related Documentation

- **SQL Server**: [SQL Server 2025 Installation](sql-server-2025.md)
- **Power BI Desktop**: Regular version (different from Report Server edition)
- **SSRS**: Power BI Report Server includes SSRS functionality
- **Updates**: [Periodic Updates Guide](../configuration/periodic-updates.md)

---

## 📚 Additional Resources

- [Power BI Report Server Documentation](https://learn.microsoft.com/en-us/power-bi/report-server/)
- [Power BI Report Server What's New](https://learn.microsoft.com/en-us/power-bi/report-server/whats-new)
- [Install Power BI Report Server](https://learn.microsoft.com/en-us/power-bi/report-server/install-report-server)
- [Power BI Desktop for Report Server](https://learn.microsoft.com/en-us/power-bi/report-server/install-powerbi-desktop)

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: On-premises Power BI and paginated reporting platform  
**URLs**: 
- Web Portal: `http://localhost/Reports`
- Report Server: `http://localhost/ReportServer`
