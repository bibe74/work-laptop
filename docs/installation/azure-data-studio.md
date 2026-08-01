# Azure Data Studio Installation

## 📋 Overview

Azure Data Studio is a modern, cross-platform database tool for data professionals using SQL Server, Azure SQL, PostgreSQL, and other databases. It provides a lightweight, code-first experience with IntelliSense, code snippets, source control integration, and extensions.

**Purpose**: Cross-platform database development and administration  
**License**: Free (open source)  
**Platform**: Windows, macOS, Linux  
**Use Case**: Modern alternative to SSMS for queries, notebooks, and cross-platform work

---

## 📥 Download Azure Data Studio

### Official Download

**Azure Data Studio Download**:
- Visit: [https://docs.microsoft.com/sql/azure-data-studio/download](https://docs.microsoft.com/sql/azure-data-studio/download)
- Or: [https://aka.ms/azuredatastudio](https://aka.ms/azuredatastudio)

### Download Options

- **Windows Installer (.exe)** - Recommended for Windows 11
- **Windows ZIP** - Portable version (no installation required)
- **User Installer** - Installs for current user only (no admin rights needed)
- **System Installer** - Installs for all users (requires admin rights)

---

## 💾 Installation

### Method 1: System Installer (Recommended)

1. **Download Installer**
   - Download **System Installer** from Azure Data Studio website
   - File: `azuredatastudio-windows-setup-[version].exe`
   - Size: ~100-150 MB

2. **Run Installer**
   - Double-click downloaded file
   - Click **Yes** on UAC prompt

3. **Installation Wizard**
   - **License Agreement**: Accept terms → **Next**
   - **Select Destination**: Use default `C:\Program Files\Azure Data Studio\` → **Next**
   - **Select Start Menu Folder**: Use default → **Next**
   - **Select Additional Tasks**:
     - ☑ Create a desktop icon
     - ☑ Add "Open with Azure Data Studio" to context menu
     - ☑ Register Code as an editor for supported file types
     - ☑ Add to PATH
   - Click **Next**
   - Click **Install**
   - Wait for installation (2-5 minutes)
   - **Launch Azure Data Studio**: Check box
   - Click **Finish**

### Method 2: User Installer (No Admin Rights)

1. **Download User Installer**
   - File: `azuredatastudio-windows-user-setup-[version].exe`

2. **Run Installer**
   - No UAC prompt needed
   - Installs to: `%LocalAppData%\Programs\Azure Data Studio`
   - Follow same wizard steps as System Installer

### Method 3: Portable (ZIP)

1. **Download ZIP**
2. **Extract** to desired location (e.g., `C:\Tools\AzureDataStudio`)
3. **Run** `azuredatastudio.exe` directly
4. **No installation** required

---

## 🚀 First Launch and Configuration

### Launch Azure Data Studio

1. **Start Application**
   - Start Menu → Azure Data Studio
   - Or: Desktop shortcut
   - Or: `azuredatastudio` from command line (if added to PATH)

2. **Welcome Screen**
   - Shows connections, recent files, and getting started guides
   - Can close or explore tutorials

### Connect to SQL Server

1. **New Connection**
   - Click **New Connection** button
   - Or: Connections icon (left sidebar) → **New Connection**

2. **Connection Details**:
   ```
   Connection type: Microsoft SQL Server
   Server: localhost (or MIRZAKHANI)
   Authentication type: Windows Authentication
   (or SQL Login with sa credentials)
   Database: <Default> (or specify database)
   Server group: <Default>
   Name (optional): Local SQL Server
   ```

3. **Advanced Options** (optional):
   - Connection timeout
   - Encrypt connection
   - Trust server certificate

4. **Connect**
   - Click **Connect**
   - Server appears in SERVERS panel

5. **Test Connection**
   - Expand server
   - Expand **Databases**
   - Right-click database → **New Query**
   - Run test query: `SELECT @@VERSION;`

---

## 🔧 Essential Configuration

### Settings and Preferences

**Access Settings**:
- File → Preferences → Settings
- Or: `Ctrl+,`

**Key Settings to Configure**:

```json
{
    // Editor
    "editor.fontSize": 14,
    "editor.fontFamily": "ComicShannsMono Nerd Font, Consolas, 'Courier New', monospace",
    "editor.wordWrap": "on",
    
    // Query Results
    "queryEditor.results.saveAsCsv.includeHeaders": true,
    "queryEditor.results.saveAsJson.includeHeaders": true,
    
    // SQL
    "sql.saveAsCsv.delimiter": ",",
    "sql.format.keywordCase": "upper",
    
    // Theme
    "workbench.colorTheme": "Visual Studio Dark"
}
```

### Install Essential Extensions

**Open Extensions**:
- View → Extensions
- Or: `Ctrl+Shift+X`

**Recommended Extensions**:

1. **SQL Server Schema Compare**
   - Compare and sync database schemas
   - Published by Microsoft

2. **SQL Server dacpac**
   - Deploy and extract .dacpac files
   - Published by Microsoft

3. **SQL Server Import**
   - Import flat files to SQL Server
   - Published by Microsoft

4. **SQL Notebooks**
   - Already included, but ensure enabled
   - Interactive SQL with visualizations

5. **Admin Pack for SQL Server**
   - Bundle of useful admin extensions
   - Published by Microsoft

6. **PostgreSQL** (if using PostgreSQL)
   - PostgreSQL support
   - Published by Microsoft

**Install Extension**:
- Search for extension
- Click **Install**
- May require reload

---

## 📓 SQL Notebooks

### Create SQL Notebook

1. **New Notebook**
   - File → New Notebook
   - Or: `Ctrl+Shift+N`

2. **Select Kernel**
   - Choose **SQL**
   - Connect to database

3. **Add Code Cell**
   - Click **+ Code** button
   - Enter SQL query:
   ```sql
   SELECT TOP 10 *
   FROM sys.tables;
   ```

4. **Run Cell**
   - Click **Run** button (play icon)
   - Or: `F5`
   - Results display inline

5. **Add Markdown Cell**
   - Click **+ Text** button
   - Add documentation, notes, explanations
   - Supports Markdown formatting

6. **Save Notebook**
   - File → Save
   - Extension: `.ipynb` (Jupyter notebook format)

### Notebook Use Cases

- **Data Exploration**: Query and visualize data
- **Documentation**: Combine code, results, and explanations
- **Tutorials**: Create step-by-step guides
- **Reporting**: Generate reports with charts
- **Sharing**: Share notebooks with team

---

## 🔌 Connect to Multiple Data Sources

Azure Data Studio supports:

### SQL Server / Azure SQL
- Already configured (see above)

### PostgreSQL

1. **Install PostgreSQL Extension**
   - Extensions → Search "PostgreSQL"
   - Install

2. **New Connection**
   - Connection type: PostgreSQL
   - Server: localhost (or remote server)
   - Authentication: Password
   - Database: postgres (or specific database)

### MySQL / MariaDB

1. **Install MySQL Extension** (if available)
2. **Or use DBeaver** for MySQL connections
   - Azure Data Studio focuses on SQL Server/Azure SQL/PostgreSQL

---

## 🎯 Key Features

### Query Editor

- **IntelliSense**: Auto-complete for SQL objects
- **Code Snippets**: Pre-built SQL templates (`sql` prefix)
- **Peek Definition**: View object definitions inline
- **Formatting**: Format SQL code (`Shift+Alt+F`)
- **Multi-cursor**: Edit multiple lines simultaneously

### Integrated Terminal

- **Open Terminal**: View → Integrated Terminal
- **PowerShell, cmd, bash** support
- **Run scripts**: Execute PowerShell or bash commands
- **sqlcmd**: Run sqlcmd commands directly

### Source Control Integration

- **Git Integration**: Built-in Git support
- **Version Control**: Commit SQL scripts to Git
- **Branch Management**: Create, switch, merge branches
- **Diff View**: Compare file versions

### Extensions Ecosystem

- **Marketplace**: Extensions → Browse marketplace
- **Community Extensions**: Third-party extensions
- **Themes**: Customize appearance
- **Language Packs**: Localization

---

## 🔄 Updates

Azure Data Studio updates automatically by default.

**Check for Updates Manually**:
1. Help → Check for Updates
2. Or: Notification appears when update available
3. Click **Update Now**
4. Azure Data Studio restarts with new version

**Update Frequency**: Monthly (similar to VS Code)

**Disable Auto-Updates** (not recommended):
- File → Preferences → Settings
- Search: "update mode"
- Change to "manual"

---

## ✅ Verification Checklist

- [ ] Azure Data Studio installed
- [ ] Can launch Azure Data Studio
- [ ] Connected to SQL Server (localhost)
- [ ] Can run SQL query successfully
- [ ] Can browse database objects (tables, views, etc.)
- [ ] Created and ran SQL Notebook
- [ ] Essential extensions installed
- [ ] IntelliSense working in query editor
- [ ] Integrated terminal accessible
- [ ] Git integration visible (Source Control panel)

---

## 🐛 Troubleshooting

### Cannot Connect to SQL Server

**Issue**: Connection fails with error

**Solutions**:
1. Verify SQL Server service is running:
   ```powershell
   Get-Service MSSQLSERVER
   ```
2. Check authentication method (Windows vs. SQL)
3. Verify server name is correct (`localhost`, `MIRZAKHANI`, or `.\SQLEXPRESS`)
4. Check SQL Server configuration allows remote connections
5. Verify firewall allows SQL Server traffic (port 1433)

### Extensions Not Installing

**Issue**: Extension installation fails

**Solutions**:
1. Check internet connection
2. Restart Azure Data Studio
3. Clear extension cache:
   - Close Azure Data Studio
   - Delete: `%USERPROFILE%\.azuredatastudio\extensions`
   - Reopen and reinstall extensions
4. Check proxy settings if behind corporate firewall

### Slow Performance

**Issue**: Azure Data Studio is slow or freezes

**Solutions**:
1. Disable unused extensions
2. Reduce result set size (use `TOP` clause)
3. Close unused query tabs
4. Increase memory allocation (if very large datasets)
5. Check for pending updates

### IntelliSense Not Working

**Issue**: Auto-complete not showing suggestions

**Solutions**:
1. Ensure connected to database
2. Refresh IntelliSense cache: `Ctrl+Shift+P` → "Refresh IntelliSense Cache"
3. Check settings: `mssql.intelliSense.enableIntelliSense` is true
4. Reload window: `Ctrl+Shift+P` → "Reload Window"

---

## 📚 Learning Resources

### Microsoft Documentation

- [Azure Data Studio Documentation](https://docs.microsoft.com/sql/azure-data-studio/)
- [SQL Notebooks Tutorial](https://docs.microsoft.com/sql/azure-data-studio/notebooks/notebooks-guidance)
- [Extensions Guide](https://docs.microsoft.com/sql/azure-data-studio/extensions/add-extensions)
- [Keyboard Shortcuts](https://docs.microsoft.com/sql/azure-data-studio/keyboard-shortcuts)

### Tutorials

- **Getting Started**: Help → Welcome
- **Sample Notebooks**: File → Open File → Browse sample notebooks
- **Interactive Tutorials**: Built into Azure Data Studio

---

## 🔗 Related Documentation

- **SQL Server**: [SQL Server 2025](sql-server-2025.md)
- **SSMS**: [SQL Server Management Studio](ssms.md)
- **VS Code**: Installed via [Ninite](ninite.md)
- **Updates**: [Periodic Updates Guide](../configuration/periodic-updates.md)

---

## 💡 Azure Data Studio vs. SSMS

| Feature | Azure Data Studio | SSMS |
|---------|------------------|------|
| **Platform** | Windows, macOS, Linux | Windows only |
| **UI** | Modern, lightweight, VS Code-based | Traditional Windows UI |
| **Query Editor** | Modern IntelliSense, snippets | Classic IntelliSense |
| **Notebooks** | ✅ SQL Notebooks support | ❌ Not supported |
| **Extensions** | ✅ Rich extension ecosystem | ❌ Limited |
| **Source Control** | ✅ Built-in Git integration | ❌ External tools needed |
| **Object Explorer** | Basic | Comprehensive |
| **Database Design** | ❌ Limited | ✅ Full designer tools |
| **SSIS/SSAS/SSRS** | ❌ Not supported | ✅ Full support |
| **Performance Tools** | Basic | Advanced (profiler, tuning advisor, etc.) |
| **Best For** | Queries, notebooks, cross-platform, modern workflows | Database administration, design, BI projects |

**Recommendation**: Use **both tools** - SSMS for admin and design work, Azure Data Studio for queries and notebooks.

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Cross-platform database development and SQL notebooks  
**Complements**: SQL Server Management Studio (SSMS)
