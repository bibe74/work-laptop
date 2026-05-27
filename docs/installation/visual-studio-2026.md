# Visual Studio Community 2026 Installation

## 📋 Overview

Visual Studio Community 2026 is the latest version of Microsoft's integrated development environment (IDE). This installation includes multiple workloads for web development, cloud development, data processing, and data science.

**Edition**: Visual Studio Community 2026 (free for individual developers)  
**Workloads**: ASP.NET and web development, Azure and AI development, Node.js development, Data storage and processing, Data science and analytical applications  
**Purpose**: Modern application development, web development, cloud development, and data science

**Note**: This is in addition to Visual Studio 2019 (for legacy SQL Server BI projects).

---

## 📥 Download Visual Studio 2026

### Official Download

**Visual Studio 2026 Downloads**:
- Visit: [https://visualstudio.microsoft.com/downloads/](https://visualstudio.microsoft.com/downloads/)
- Click **Download** under **Visual Studio 2026 Community** (free version)

### Download

1. **Click Download**
   - File: `vs_community.exe` (web installer, ~3-5 MB)
   - Latest version of VS 2026

2. **Save Installer**
   - Save to Downloads or preferred location

---

## 💾 Installation

### Prerequisites

- **Windows 11** ✅
- **Minimum 8 GB RAM**, Recommended 16+ GB (32 GB on MIRZAKHANI ✅)
- **Disk Space**: Minimum 30 GB, Recommended 100+ GB for all workloads
- **Administrator Rights**
- **.NET 8.0 or later** (installed automatically with VS 2026)

### Installation Steps

1. **Run Visual Studio Installer**
   - Run downloaded `vs_community.exe`
   - Click **Yes** on UAC prompt

2. **Visual Studio Installer Loads**
   - Installer downloads necessary components
   - Visual Studio Installer application opens

3. **Select Workloads**
   
   On the **Workloads** tab, select the following:
   
   ✅ **ASP.NET and web development**
   - Build web applications using ASP.NET Core, HTML/CSS, JavaScript
   - REST APIs, Blazor, MVC, Web API
   - Includes: IIS Express, web development tools, debugging tools
   
   ✅ **Azure development** (may be named "Azure and AI development")
   - Cloud application development for Microsoft Azure
   - Azure Functions, App Services, Storage
   - AI and machine learning tools
   - Includes: Azure SDK, Azure Functions tools, Azure Storage emulator
   
   ✅ **Node.js development**
   - JavaScript and TypeScript development
   - Node.js runtime and npm package management
   - React, Angular, Vue.js support
   - Includes: Node.js runtime, npm, debugging tools
   
   ✅ **Data storage and processing**
   - SQL Server Data Tools (SSDT)
   - SSIS, SSRS, SSAS project development
   - Database project templates
   - Azure Data Lake and Stream Analytics tools
   
   ✅ **Data science and analytical applications**
   - Python and R development environments
   - Data science libraries and tools
   - Jupyter notebooks integration
   - Machine learning and AI development
   - Includes: Python, R, F#, Anaconda

4. **Individual Components** (Optional)
   
   Click **Individual components** tab to review:
   
   Automatically selected with workloads above:
   - .NET 8.0 SDK and runtime
   - .NET Core development tools
   - SQL Server Data Tools
   - Python language support
   - R language support
   - Node.js development support
   - Azure development tools
   - Web development tools
   - TypeScript SDK
   - Git for Windows
   
   **Optional but recommended**:
   - ✅ GitHub extension for Visual Studio
   - ✅ Live Share (for collaboration)
   - ✅ IntelliCode (AI-assisted development)
   - ✅ Container development tools
   - ✅ .NET Multi-platform App UI (.NET MAUI) - if doing mobile development

5. **Language Packs** (optional)
   
   Click **Language packs** tab:
   - English selected by default
   - Add other languages if needed

6. **Installation Locations**
   
   Click **Installation locations** tab (optional):
   - **Visual Studio IDE**: Default `C:\Program Files\Microsoft Visual Studio\2026\Community`
   - **Download cache**: Temporary location
   - **Shared components**: Shared tools and SDKs
   - Change if needed, otherwise use defaults

7. **Install**
   
   - Review disk space requirements (shown at bottom)
   - **All selected workloads**: ~40-60 GB
   - Click **Install**

8. **Installation Progress**
   
   - Downloads and installs selected workloads
   - Progress shows each component being installed
   - Duration: 60-120 minutes depending on internet speed
   - Can continue working during installation

9. **Installation Complete**
   
   - "Installation succeeded" message
   - Option to launch Visual Studio
   - Click **Launch** or close installer

---

## 🚀 First Launch and Configuration

### Launch Visual Studio 2026

1. **Start Visual Studio**
   - Start Menu → Visual Studio 2026
   - Or: Visual Studio Installer → Launch

2. **Sign In** (recommended)
   - Sign in with Microsoft account
   - Unlocks additional features and cloud services
   - Syncs settings across devices
   - Can skip and sign in later

3. **Development Settings**
   - Choose development settings profile:
     - **General** (recommended for multiple types)
     - **Web Development** (if primarily web/cloud)
     - **Python** (if primarily data science)
   - These can be changed later
   - Click **Start Visual Studio**

4. **Color Theme**
   - Blue (default), Light, Dark, Blue (Extra Contrast), or other themes
   - Can change later in Tools → Options → Environment → General

### Initial Configuration

1. **Update Visual Studio** (important!)
   - Visual Studio may have updates available
   - Help → Check for Updates
   - Install any available updates
   - Restart if required

2. **Verify Workload Installation**
   - File → New → Project
   - Should see templates for:
     - **ASP.NET Core Web App**
     - **Azure Functions**
     - **Node.js Console Application**
     - **Integration Services Project** (SSIS)
     - **Python Application**
     - **R Application**
   - If templates missing, see troubleshooting section

---

## 🔧 Post-Installation Configuration

### Configure Python Environment

1. **Python Environments**
   - View → Other Windows → Python Environments
   - Shows installed Python distributions
   - Can add custom Python environments
   - Install Python packages via pip

2. **Install Common Packages**
   ```python
   # In Python environment, install common data science packages
   # pandas, numpy, matplotlib, scikit-learn, etc.
   # Or use Anaconda environment (included)
   ```

### Configure Azure Tools

1. **Sign in to Azure** (if using Azure)
   - View → Cloud Explorer
   - Sign in with Azure account
   - Access Azure resources directly from IDE

### Configure Node.js

1. **Verify Node.js Installation**
   ```powershell
   node --version
   npm --version
   ```

2. **Configure npm**
   - Tools → Options → Projects and Solutions → Web Package Management → External Web Tools
   - Configure paths for npm, node

### Configure SQL Server Connection

1. **SQL Server Object Explorer**
   - View → SQL Server Object Explorer
   - Add SQL Server: `localhost` or MIRZAKHANI
   - Authentication: Windows Authentication
   - Browse databases

---

## 📝 Test Each Workload

### Test ASP.NET Core Web App

1. **File → New → Project**
2. **Search**: "ASP.NET Core Web App"
3. **Select**: ASP.NET Core Web App (Model-View-Controller or Razor Pages)
4. **Project name**: `TestWebApp`
5. **Click Create**
6. **Framework**: .NET 8.0 or later
7. **Click Create**
8. **Press F5** to run
9. **Verify**: Browser opens with running web application

### Test Azure Function

1. **File → New → Project**
2. **Search**: "Azure Functions"
3. **Select**: Azure Functions
4. **Project name**: `TestAzureFunction`
5. **Click Create**
6. **Trigger**: HTTP trigger
7. **Click Create**
8. **Verify**: Function project created with template code

### Test Node.js Application

1. **File → New → Project**
2. **Search**: "Node.js"
3. **Select**: Blank Node.js Console Application
4. **Project name**: `TestNodeApp`
5. **Click Create**
6. **Verify**: JavaScript file opens with Node.js project

### Test SSIS Project

1. **File → New → Project**
2. **Search**: "Integration Services"
3. **Select**: Integration Services Project
4. **Project name**: `TestSSIS_VS2026`
5. **Click Create**
6. **Verify**: Package designer opens

### Test Python Application

1. **File → New → Project**
2. **Search**: "Python"
3. **Select**: Python Application
4. **Project name**: `TestPythonApp`
5. **Python environment**: Select installed Python or Anaconda
6. **Click Create**
7. **Verify**: Python file opens
8. **Run**: Press F5 (after adding print("Hello") or similar)

### Test R Application

1. **File → New → Project**
2. **Search**: "R"
3. **Select**: R Project
4. **Project name**: `TestRProject`
5. **Click Create**
6. **Verify**: R files and environment available

---

## ⚙️ Essential Visual Studio Configuration

### General Settings

```
Tools → Options → Environment → General
- Color theme: Choose preference
- Show status bar: ✅
- Automatically adjust visual experience based on client performance: ✅
```

### Text Editor Settings

```
Tools → Options → Text Editor → All Languages → General
☑ Line numbers
☑ Navigation bar
☑ Enable virtual space (optional)

Tools → Options → Text Editor → All Languages → Scroll Bars
☑ Use map mode for vertical scroll bar
```

### Auto-Save

```
Tools → Options → Environment → AutoRecover
☑ Save AutoRecover information every: 5 minutes
```

### IntelliCode (AI Assistance)

```
Extensions → IntelliCode
- Should be enabled by default
- Provides AI-assisted code completions
```

### Source Control

```
Tools → Options → Source Control → Plug-in Selection
Current source control plug-in: Git

Git settings:
Tools → Options → Source Control → Git Global Settings
- Configure Git user name and email
```

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
- Visual Studio updates frequently
- Major version updates may require download of new installer

### Update Workloads and Components

1. **Visual Studio Installer**
2. **Click Modify** next to installed version
3. **Add/remove workloads** as needed
4. **Click Modify** to apply changes

---

## ✅ Verification Checklist

- [ ] Visual Studio 2026 Community installed
- [ ] All 5 workloads installed (ASP.NET, Azure, Node.js, Data storage, Data science)
- [ ] Visual Studio launches successfully
- [ ] Signed in with Microsoft account (optional)
- [ ] All updates installed
- [ ] Can create ASP.NET Core web app
- [ ] Can create Azure Function project
- [ ] Can create Node.js project
- [ ] Can create SSIS project
- [ ] Can create Python application
- [ ] Can create R project
- [ ] SQL Server Object Explorer connects to database
- [ ] Python environments configured
- [ ] Node.js accessible
- [ ] Azure cloud explorer available (if using Azure)

---

## 🐛 Troubleshooting

### Project Templates Not Showing

**Issue**: Cannot find expected project templates

**Solutions**:
1. Verify workloads are installed: Visual Studio Installer → Modify
2. Repair Visual Studio installation: Visual Studio Installer → More → Repair
3. Reset Visual Studio template cache:
   ```cmd
   devenv /resetuserdata
   devenv /installvstemplates
   ```

### Python/R Not Working

**Issue**: Python or R environment not found

**Solutions**:
1. Verify Data science workload is installed
2. View → Other Windows → Python Environments (or R Interactive)
3. Add Python/R manually if needed
4. Install Anaconda separately if using custom Python

### Visual Studio Won't Launch

**Issue**: VS crashes on startup

**Solutions**:
1. Reset settings:
   ```cmd
   devenv /resetuserdata
   devenv /resetsettings
   ```
2. Clear component model cache:
   - Delete: `%LocalAppData%\Microsoft\VisualStudio\17.0\ComponentModelCache`
3. Run as administrator
4. Repair installation via Visual Studio Installer

### Node.js Projects Won't Debug

**Issue**: Cannot debug Node.js applications

**Solutions**:
1. Ensure Node.js is in PATH
2. Tools → Options → Projects and Solutions → Web Package Management
3. Verify Node.js path
4. Reinstall Node.js if needed

---

## 🔗 Related Documentation

- **Visual Studio 2019**: [VS 2019 Installation](visual-studio-2019.md) (for legacy SSIS/SSRS/SSAS)
- **SQL Server**: [SQL Server 2025](sql-server-2025.md)
- **Python/Data Science**: Future data science development guides
- **Azure Development**: Future Azure development guides
- **Updates**: [Periodic Updates Guide](../configuration/periodic-updates.md)

---

## 📚 Additional Resources

- [Visual Studio 2026 Documentation](https://learn.microsoft.com/en-us/visualstudio/ide/)
- [ASP.NET Core Documentation](https://learn.microsoft.com/en-us/aspnet/core/)
- [Azure Development](https://learn.microsoft.com/en-us/azure/developer/)
- [Python in Visual Studio](https://learn.microsoft.com/en-us/visualstudio/python/)
- [Node.js in Visual Studio](https://learn.microsoft.com/en-us/visualstudio/javascript/nodejs-with-azure)

---

## 📝 Notes on Multiple Visual Studio Versions

You now have both Visual Studio 2019 and 2026 installed:

**Visual Studio 2019**:
- Use for legacy SQL Server BI projects (SSIS, SSRS, SSAS)
- Compatible with SQL Server 2025 BI tools
- Data storage and processing workload

**Visual Studio 2026**:
- Use for modern web development (ASP.NET Core, Blazor)
- Azure cloud development
- Node.js and JavaScript development
- Python and R data science projects
- Latest .NET development
- Modern BI and data processing projects

Both versions can coexist without conflicts. They install to separate directories and can run simultaneously.

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Modern application development, web, cloud, and data science  
**Workloads**: ASP.NET, Azure/AI, Node.js, Data storage, Data science
