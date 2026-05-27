# Visual Studio Community 2019 Installation

## 📋 Overview

Visual Studio Community 2019 is required for developing SQL Server Integration Services (SSIS), SQL Server Reporting Services (SSRS), and SQL Server Analysis Services (SSAS) projects.

**Edition**: Visual Studio Community 2019 (free for individual developers)  
**Workload**: Data storage and processing  
**Purpose**: BI project development (SSIS, SSRS, SSAS)

**Note**: Visual Studio Code (already installed via Ninite) is different from Visual Studio full IDE.

---

## 📥 Download Visual Studio 2019

### Official Download

**Visual Studio 2019 Downloads**:
- Visit: [https://visualstudio.microsoft.com/vs/older-downloads/](https://visualstudio.microsoft.com/vs/older-downloads/)
- Sign in with Microsoft account (required for download)
- Expand **Visual Studio 2019** section
- Download **Visual Studio Community 2019** (free version)

### Alternative: Direct Links

- Community 2019: Look for latest version (16.11.x is final version of VS 2019)
- File: `vs_community.exe` (web installer, ~3 MB)

**Why Visual Studio 2019?**
- SQL Server 2025 BI projects may require VS 2019 extensions
- Visual Studio 2022 compatibility varies for SQL Server Data Tools (SSDT)
- VS 2019 is the stable, tested version for SQL Server 2025 at time of writing

---

## 💾 Installation

### Prerequisites

- **Windows 11** ✅
- **Minimum 4 GB RAM**, Recommended 8+ GB (32 GB on MIRZAKHANI ✅)
- **Disk Space**: Minimum 20 GB, Recommended 50+ GB for full installation
- **Administrator Rights**
- **.NET Framework 4.7.2 or later** (included with Windows 11)

### Installation Steps

1. **Run Visual Studio Installer**
   - Run downloaded `vs_community.exe`
   - Click **Yes** on UAC prompt

2. **Visual Studio Installer Loads**
   - Installer downloads necessary components (1-2 minutes)
   - Visual Studio Installer application opens

3. **Select Workload**
   
   On the **Workloads** tab, select:
   
   ✅ **Data storage and processing**
   
   This installs:
   - SQL Server Data Tools (SSDT) for Visual Studio
   - Support for SSIS, SSRS, SSAS projects
   - Database project templates
   - Azure Data Lake and Stream Analytics tools (optional components)

4. **Individual Components** (Optional)
   
   Click **Individual components** tab to view included components:
   
   Automatically selected with Data storage and processing workload:
   - SQL Server Data Tools (SSDT)
   - SQL Server Integration Services Projects
   - SQL Server Analysis Services Projects  
   - SQL Server Reporting Services Projects
   - .NET Framework development tools
   - NuGet package manager
   - Text template transformation
   
   **Optional but recommended**:
   - ✅ GitHub extension for Visual Studio (for version control)
   - ✅ Live Share (for collaboration)

5. **Language Packs** (optional)
   
   Click **Language packs** tab:
   - English selected by default
   - Add other languages if needed

6. **Installation Locations**
   
   Click **Installation locations** tab (optional):
   - **Visual Studio IDE**: Default `C:\Program Files (x86)\Microsoft Visual Studio\2019\Community`
   - **Download cache**: Temporary location for installers
   - **Shared components**: Shared tools and SDKs
   - **Change if needed**, otherwise use defaults

7. **Install**
   
   - Review disk space requirements (shown at bottom)
   - **Data storage and processing workload**: ~10-15 GB
   - Click **Install**

8. **Installation Progress**
   
   - Downloads and installs selected workloads
   - Progress shows each component being installed
   - Duration: 30-60 minutes depending on internet speed
   - Can continue working during installation

9. **Installation Complete**
   
   - "Installation succeeded" message
   - Option to launch Visual Studio
   - Click **Launch** or close installer

---

## 🚀 First Launch and Configuration

### Launch Visual Studio 2019

1. **Start Visual Studio**
   - Start Menu → Visual Studio 2019
   - Or: Visual Studio Installer → Launch

2. **Sign In** (optional but recommended)
   - Sign in with Microsoft account
   - Unlocks additional features
   - Syncs settings across devices
   - Can skip and sign in later

3. **Development Settings**
   - Choose **General** or **SQL** development settings
   - These can be changed later
   - Click **Start Visual Studio**

4. **Color Theme**
   - Blue (default), Light, Dark, or Blue (Extra Contrast)
   - Can change later in Tools → Options → Environment → General

### Initial Configuration

1. **Update Visual Studio** (important!)
   - Visual Studio may have updates available
   - Help → Check for Updates
   - Install any available updates
   - Restart if required

2. **Verify Workload Installation**
   - Create new project: File → New → Project
   - Should see templates for:
     - **Integration Services Project** (SSIS)
     - **Report Server Project** (SSRS)  
     - **Analysis Services Tabular Project** (SSAS)
   - If templates missing, see troubleshooting section

---

## 🔧 Install SQL Server Data Tools Extensions

### Install SSIS, SSRS, SSAS Extensions

If project templates are not showing after installation:

1. **Open Extensions Manager**
   - Extensions → Manage Extensions
   - Or: Tools → Extensions and Updates (older VS versions)

2. **Search Online**
   - Click **Online** in left pane
   - Search for each:

**Integration Services (SSIS)**:
- Search: "SQL Server Integration Services Projects"
- By Microsoft
- Click **Download**

**Reporting Services (SSRS)**:
- Search: "Microsoft Reporting Services Projects"
- By Microsoft  
- Click **Download**

**Analysis Services (SSAS)**:
- Search: "Microsoft Analysis Services Projects"
- By Microsoft
- Click **Download**

3. **Close Visual Studio**
   - Extensions install after closing VS
   - VSIX Installer runs automatically
   - Click **Modify** on each extension
   - Wait for installation to complete

4. **Restart Visual Studio**
   - Extensions should now be installed
   - Verify project templates are available

---

## 📝 Create Test Projects

### Test SSIS Project

1. **File → New → Project**
2. **Search**: "Integration Services"
3. **Select**: Integration Services Project
4. **Project name**: `TestSSIS`
5. **Click Create**
6. **Verify**: Package designer opens with blank package

### Test SSRS Project

1. **File → New → Project**
2. **Search**: "Report Server"
3. **Select**: Report Server Project
4. **Project name**: `TestSSRS`
5. **Click Create**
6. **Verify**: Solution Explorer shows report project structure

### Test SSAS Project

1. **File → New → Project**
2. **Search**: "Analysis Services"
3. **Select**: Analysis Services Tabular Project
4. **Project name**: `TestSSAS`
5. **Workspace server**: `localhost` (your SSAS Tabular instance)
6. **Click OK**
7. **Verify**: Model designer opens

---

## ⚙️ Essential Visual Studio Configuration

### Configure Auto-Save

```
Tools → Options → Environment → AutoRecover
☑ Save AutoRecover information every: 5 minutes
```

### Line Numbers

```
Tools → Options → Text Editor → All Languages → General
☑ Line numbers
```

### Source Control

```
Tools → Options → Source Control → Plug-in Selection
Current source control plug-in: Git
```

### Connect to SQL Server

1. **View → SQL Server Object Explorer**
   - Or: `Ctrl+\, Ctrl+S`

2. **Add SQL Server**
   - Click **Add SQL Server** icon
   - Server name: `localhost` or MIRZAKHANI
   - Authentication: Windows Authentication
   - Click **Connect**

3. **Browse Databases**
   - Can browse and query databases directly from VS

---

## 🔄 Updates

### Check for Visual Studio Updates

1. **Help → Check for Updates**
   - Shows available updates
   - Click **Update** to install

2. **Visual Studio Installer**
   - Launch Visual Studio Installer
   - Shows update button if updates available
   - Click **Update**

### Update Schedule

- Include in [monthly update routine](../configuration/periodic-updates.md)
- Visual Studio updates monthly (approximately)
- Extensions update independently

### Update Extensions

1. **Extensions → Manage Extensions**
2. **Updates** section (left pane)
3. **Select all** updates
4. **Update**
5. **Close Visual Studio** to apply updates

---

## ✅ Verification Checklist

- [ ] Visual Studio 2019 Community installed
- [ ] Data storage and processing workload installed
- [ ] Visual Studio launches successfully
- [ ] Signed in with Microsoft account (optional)
- [ ] All updates installed
- [ ] SSIS extension installed (Integration Services Projects template available)
- [ ] SSRS extension installed (Report Server Project template available)
- [ ] SSAS extension installed (Analysis Services Tabular Project template available)
- [ ] Can connect to SQL Server via SQL Server Object Explorer
- [ ] Can create test SSIS package
- [ ] Can create test SSRS report
- [ ] Can create test SSAS project

---

## 🐛 Troubleshooting

### Project Templates Not Showing

**Issue**: Cannot find SSIS, SSRS, or SSAS project templates

**Solutions**:
1. Verify Data storage and processing workload is installed:
   - Visual Studio Installer → Modify → Check workload is selected
2. Install extensions manually (see Install SSIS, SSRS, SSAS Extensions section)
3. Reset Visual Studio template cache:
   ```cmd
   devenv /installvstemplates
   ```
4. Repair Visual Studio installation:
   - Visual Studio Installer → More → Repair

### Visual Studio Won't Launch

**Issue**: VS crashes on startup or shows error

**Solutions**:
1. Reset Visual Studio settings:
   ```cmd
   devenv /resetuserdata
   ```
2. Clear component model cache:
   - Delete: `%LocalAppData%\Microsoft\VisualStudio\16.0\ComponentModelCache`
3. Repair installation via Visual Studio Installer

### Cannot Connect to SQL Server

**Issue**: SQL Server Object Explorer cannot connect

**Solutions**:
1. Verify SQL Server service is running
2. Check server name (use `localhost` or `.` for local instance)
3. Verify Windows Authentication is enabled
4. Check SQL Server allows remote connections

### SSIS Package Designer Doesn't Load

**Issue**: Cannot open SSIS package in designer

**Solutions**:
1. Ensure Integration Services extension is installed
2. Check Integration Services is installed on machine (SQL Server component)
3. Reinstall SSIS extension from Extensions → Manage Extensions

---

## 🔗 Related Documentation

- **SQL Server Installation**: [SQL Server 2025](sql-server-2025.md)
- **SSMS**: [SQL Server Management Studio](ssms.md)
- **Project Development**: Future guides on SSIS, SSRS, SSAS development
- **Updates**: [Periodic Updates Guide](../configuration/periodic-updates.md)

---

## 📚 Additional Resources

- [Visual Studio 2019 Documentation](https://learn.microsoft.com/en-us/visualstudio/ide/)
- [SQL Server Data Tools (SSDT)](https://learn.microsoft.com/en-us/sql/ssdt/download-sql-server-data-tools-ssdt)
- [SSIS in Visual Studio](https://learn.microsoft.com/en-us/sql/integration-services/ssis-how-to-create-an-etl-package)
- [SSRS in Visual Studio](https://learn.microsoft.com/en-us/sql/reporting-services/tools/reporting-services-in-sql-server-data-tools)

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: BI project development platform (SSIS, SSRS, SSAS)  
**Workload**: Data storage and processing
