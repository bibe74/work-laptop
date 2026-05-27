# Power BI Desktop Installation

## 📋 Overview

Power BI Desktop is Microsoft's free business intelligence tool for creating interactive reports and visualizations. This is the **standard version** for publishing to Power BI Service (cloud).

**Version**: Standard Power BI Desktop  
**Purpose**: Create and publish reports to Power BI Service (cloud)  
**License**: Free  
**Note**: Different from Power BI Desktop for Report Server

---

## 📥 Download Power BI Desktop

### Official Download

**Power BI Desktop Download**:
- Visit: [https://powerbi.microsoft.com/desktop/](https://powerbi.microsoft.com/desktop/)
- Or: [https://www.microsoft.com/en-us/download/details.aspx?id=58494](https://www.microsoft.com/en-us/download/details.aspx?id=58494)

### Download Options

**Option 1: Microsoft Store (Recommended)**
- Automatic updates
- Easy installation
- No admin rights required

**Option 2: Direct Download**
- Manual updates required
- More control over versions
- May require admin rights

---

## 💾 Installation

### Method 1: Microsoft Store (Recommended)

1. **Open Microsoft Store**
   - Start Menu → Microsoft Store

2. **Search for Power BI Desktop**
   - Search: "Power BI Desktop"
   - Select **Power BI Desktop** by Microsoft Corporation

3. **Install**
   - Click **Get** or **Install**
   - Automatic installation
   - No restart required
   - Updates automatically through Microsoft Store

### Method 2: Direct Download

1. **Download Installer**
   - Click **Download** from Power BI website
   - File: `PBIDesktopSetup_x64.exe` or `PBIDesktopSetup.msi`
   - Size: ~600-700 MB

2. **Run Installer**
   - Run downloaded file
   - Click **Yes** on UAC prompt

3. **Installation Wizard**
   - Select language (English default)
   - Click **Next**
   - Accept license terms
   - Click **Next**
   - Choose installation location (default recommended)
   - Click **Install**
   - Wait for installation (5-10 minutes)
   - Click **Finish**

---

## 🚀 First Launch and Configuration

### Launch Power BI Desktop

1. **Start Application**
   - Start Menu → Microsoft Power BI Desktop
   - Or: Search for "Power BI Desktop"

2. **Sign In** (optional but recommended)
   - Click **Sign in** in upper right
   - Use Microsoft account or work/school account
   - Required for publishing to Power BI Service
   - Can skip and work locally without signing in

3. **Welcome Screen**
   - Shows sample reports and templates
   - Can close or explore samples
   - Click **X** to start with blank report

### Initial Setup

1. **Configure Options**
   - File → Options and settings → Options
   
2. **General Settings**:
   ```
   Global:
   - Data Load: Configure import/DirectQuery preferences
   - Security: Configure privacy levels
   - Regional Settings: Set locale and currency
   
   Current File:
   - Data Load: File-specific settings
   - Auto recovery: Enable autosave
   ```

3. **Privacy Settings**:
   ```
   File → Options → Privacy
   - Choose privacy level for data sources
   - Recommended: Organizational for corporate data
   ```

4. **Auto-Save Settings**:
   ```
   File → Options → Current File → Data Load
   ☑ Auto save: Enable for current file
   ```

---

## 📊 Create First Report

### Quick Test Report

1. **Get Data**
   - Home → Get Data → Excel (or other source)
   - Or: Use sample dataset
   - Home → Get Data → Sample datasets
   - Select "Financial Sample" or other sample
   - Click **Load**

2. **Create Visualization**
   - In Fields pane (right), drag field to canvas
   - Select visualization type from Visualizations pane
   - Configure fields and formatting

3. **Save Report**
   - File → Save As
   - Choose location
   - File extension: `.pbix`
   - Save locally or to OneDrive

4. **Publish to Power BI Service** (optional)
   - Home → Publish
   - Sign in if not already signed in
   - Select workspace in Power BI Service
   - Report uploads to cloud

---

## 🔧 Essential Configuration

### Configure Data Source Settings

```
File → Options → Data source settings
- Manage credentials for data sources
- Edit permissions
- Clear permissions if needed
```

### Enable/Disable Preview Features

```
File → Options → Preview features
- Check experimental features to enable
- Examples:
  - New format pane
  - Updated ribbon
  - New modeling view features
```

### Configure Auto Recovery

```
File → Options → Current File → Data Load
☑ AutoRecover: Save every 10 minutes (recommended)
```

### Install Custom Visuals

1. **Insert → Get more visuals**
2. **AppSource or From a file**
3. **Search and install** custom visualizations
4. **Manage visuals**: Home → More visuals → Manage visuals

---

## 📦 Power BI Desktop vs. Report Server Edition

You may have both versions installed:

| Feature | Power BI Desktop (Standard) | Power BI Desktop for Report Server |
|---------|---------------------------|-----------------------------------|
| **Installation** | Microsoft Store or download | Separate installer |
| **Publish To** | Power BI Service (cloud) | Power BI Report Server (on-prem) |
| **Updates** | Monthly | Quarterly (aligned with Report Server) |
| **Features** | Latest features | Subset of features (delayed release) |
| **Folder** | `C:\Program Files\Microsoft Power BI Desktop\` | `C:\Program Files\Microsoft Power BI Desktop RS\` |
| **Use Case** | Cloud-based reporting | On-premises reporting |

**Both can be installed side-by-side** without conflicts.

---

## 🔄 Updates

### Microsoft Store Version

- Updates automatically through Microsoft Store
- Check manually: Microsoft Store → Library → Get updates
- Settings → Update apps automatically

### Direct Download Version

**Frequency**: Monthly (Microsoft releases monthly updates)

1. **Check Current Version**
   - Power BI Desktop → File → Help → About
   - Note version and date (e.g., "May 2026")

2. **Check for Updates**
   - Power BI Desktop prompts on launch when update available
   - Or visit Power BI download page to check latest version

3. **Download and Install Update**
   - Download latest installer from Power BI website
   - Run installer (upgrades existing installation)
   - No uninstall needed
   - Reports (.pbix files) remain compatible

4. **Review Release Notes**
   - Always review what's new in the update
   - Available on Power BI blog: [https://powerbi.microsoft.com/blog/](https://powerbi.microsoft.com/blog/)

---

## 🔗 Connect to Data Sources

### Common Data Sources

Power BI Desktop connects to:

**Databases**:
- SQL Server (including SSAS, SSIS)
- Azure SQL Database
- PostgreSQL
- MySQL / MariaDB
- Oracle
- And many more

**Files**:
- Excel (.xlsx, .xls)
- CSV, TXT
- JSON, XML
- Power BI datasets

**Cloud Services**:
- SharePoint
- Azure services
- Google Analytics
- Salesforce
- Many other cloud services

### Connect to SQL Server

1. **Home → Get Data → SQL Server**
2. **Server**: `localhost` or `MIRZAKHANI`
3. **Database** (optional): Specify database or leave blank
4. **Data Connectivity mode**:
   - **Import**: Data is loaded into Power BI
   - **DirectQuery**: Data stays in SQL Server, queries run on-demand
5. **Advanced options** (optional):
   - SQL statement (custom query)
   - Relationship columns
6. **Click OK**
7. **Select tables** to import
8. **Load or Transform**:
   - **Load**: Import data as-is
   - **Transform Data**: Open Power Query Editor for transformations

---

## 📊 Power Query Editor

### Open Power Query

- Home → Transform data
- Or: Get Data → [Source] → Transform Data

### Common Transformations

- Remove columns
- Filter rows
- Change data types
- Split columns
- Merge queries
- Append queries
- Add custom columns
- Group by

### Apply and Close

- Home → Close & Apply
- Transformations applied and data loaded into model

---

## 🎨 Custom Themes

### Apply Theme

1. **View → Themes**
2. **Select built-in theme** or **Browse for themes**
3. **Create custom theme**:
   - Create JSON file with color palette and formatting
   - View → Themes → Browse for themes
   - Select custom JSON file

---

## ✅ Verification Checklist

- [ ] Power BI Desktop installed
- [ ] Can launch Power BI Desktop
- [ ] Signed in with Microsoft account (if publishing to cloud)
- [ ] Can get data from sample dataset
- [ ] Can create basic visualization
- [ ] Can save report (.pbix file)
- [ ] Can publish to Power BI Service (if signed in and have license)
- [ ] Can connect to SQL Server
- [ ] Power Query Editor accessible
- [ ] Custom visuals marketplace accessible

---

## 🐛 Troubleshooting

### Cannot Connect to Data Source

**Issue**: Connection to SQL Server or other source fails

**Solutions**:
1. Verify data source is accessible (SQL Server running, network available)
2. Check credentials are correct
3. File → Options → Data source settings → Clear permissions and re-enter
4. For SQL Server: Ensure SQL Server allows remote connections
5. Check firewall settings

### Power BI Desktop Won't Launch

**Issue**: Application crashes on startup

**Solutions**:
1. Restart computer
2. Repair installation:
   - Direct download version: Rerun installer → Repair
   - Microsoft Store version: Settings → Apps → Power BI Desktop → Advanced options → Repair
3. Clear cache:
   - Delete: `%LocalAppData%\Microsoft\Power BI Desktop\`
4. Reinstall

### Publish to Power BI Service Fails

**Issue**: Cannot publish report to cloud

**Solutions**:
1. Ensure signed in with account that has Power BI license
2. Check internet connection
3. Verify workspace exists in Power BI Service
4. Try publishing to "My Workspace" first
5. Check file size (limit is 1 GB for .pbix files)

### Report Performance Issues

**Issue**: Report is slow or crashes

**Solutions**:
1. Reduce data volume: Apply filters at source
2. Use DirectQuery instead of Import for large datasets
3. Optimize DAX calculations
4. Reduce number of visuals on page
5. Use aggregations
6. Check data types are optimal (e.g., dates as date type, not text)

---

## 📚 Learning Resources

### Microsoft Learning

- [Power BI Guided Learning](https://learn.microsoft.com/en-us/power-bi/guided-learning/)
- [Power BI Documentation](https://learn.microsoft.com/en-us/power-bi/)
- [DAX Reference](https://learn.microsoft.com/en-us/dax/)
- [Power Query M Reference](https://learn.microsoft.com/en-us/powerquery-m/)

### Power BI Community

- [Power BI Community Forum](https://community.powerbi.com/)
- [Power BI Blog](https://powerbi.microsoft.com/blog/)
- [Guy in a Cube](https://www.youtube.com/c/GuyinaCube) - YouTube channel

---

## 🔗 Related Documentation

- **Power BI Report Server**: [Installation Guide](power-bi-report-server.md)
- **Power BI Desktop for Report Server**: Separate version for on-premises
- **SQL Server**: [SQL Server 2025](sql-server-2025.md)
- **Updates**: [Periodic Updates Guide](../configuration/periodic-updates.md)

---

## 📝 Power BI Service (Cloud)

To use full Power BI capabilities:

1. **Sign up for Power BI Service**
   - Free tier available: [https://powerbi.microsoft.com/](https://powerbi.microsoft.com/)
   - Or use work/school account with Power BI license

2. **Workspaces**
   - Create workspaces for organizing reports
   - Share reports with colleagues
   - Set up refresh schedules for datasets

3. **Publish Reports**
   - Power BI Desktop → Home → Publish
   - Select workspace
   - Report and dataset upload to cloud
   - View and share via web browser or mobile app

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Cloud-based business intelligence and reporting  
**Version**: Standard Power BI Desktop (for Power BI Service)
