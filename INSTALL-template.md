# Laptop Installation Checklist

**Computer Name**: MIRZAKHANI  
**Hardware**: Dell XPS 13 9310 (32GB RAM, 1TB SSD)  
**OS**: Windows 11  
**Installation Date**: _[To be filled when using this checklist]_

---

## 📋 Pre-Installation

- [ ] Review [README.md](README.md) for overview and technology stack
- [ ] Backup all existing data (if reinstalling)
- [ ] Copy `.env.sample` to `.env` and configure client-specific details
  - `CLIENT_NAME` - Client/company name
  - `VPN_NAME` - VPN connection name
  - `DOMAIN_NAME` - Active Directory domain
  - `DOMAIN_USER` - Domain username
- [ ] Download this repository or have access to all installation guides

---

## 🔧 Installation Steps

### 1. Windows 11 Fresh Installation
- [ ] Complete Windows 11 reset/installation
  - 📖 [Installation Guide](docs/installation/windows-11-fresh-install.md)
- [ ] Set computer name to **MIRZAKHANI**
- [ ] Complete Windows updates
- [ ] Verify Windows activation

### 2. Dell SupportAssist for Business PCs
- [ ] Download and install Dell SupportAssist
  - 📖 [Installation Guide](docs/installation/dell-supportassist.md)
- [ ] Run firmware and driver updates
- [ ] **CRITICAL**: Update BIOS (ensure AC power connected, battery >50%)
- [ ] Verify all drivers updated (chipset, network, graphics, audio, Thunderbolt)
- [ ] Restart after updates

### 3. Windows System Configuration
- [ ] Complete all Windows updates (Settings → Windows Update)
- [ ] Configure Windows settings (privacy, display, power settings)
- [ ] Enable Windows features if needed (Hyper-V, etc.)
- [ ] Verify internet connectivity

### 4. Ninite - Core Utilities Package
- [ ] Visit Ninite.com and create custom installer
  - 📖 [Installation Guide](docs/installation/ninite.md)
- [ ] Select applications:
  - [ ] Google Chrome
  - [ ] 7-Zip
  - [ ] iTunes
  - [ ] Git
  - [ ] Notepad++
  - [ ] Visual Studio Code
  - [ ] Foxit Reader
  - [ ] Google Drive for Desktop
- [ ] Download and run Ninite installer
- [ ] **Save installer** for monthly updates
- [ ] Verify all applications installed

### 5. Office 365, Microsoft Teams & Slack
- [ ] Install Office 365
  - 📖 [Installation Guide](docs/installation/office-teams-slack.md)
- [ ] Activate Office with license key
- [ ] Sign in to Office apps
- [ ] Install Microsoft Teams (Microsoft Store or desktop app)
- [ ] Sign in to Teams
- [ ] Install Slack
- [ ] Sign in to Slack workspace(s)

### 6. Additional Development Tools
- [ ] Install PowerShell 7 (Microsoft Store - preferred)
  - 📖 [Installation Guide](docs/installation/additional-dev-tools.md)
- [ ] Install Windows Subsystem for Linux (WSL)
  - [ ] Enable WSL feature
  - [ ] Install Ubuntu from Microsoft Store
  - [ ] Configure WSL user and password
- [ ] Install Docker Desktop
  - [ ] Enable WSL 2 integration
  - [ ] Configure Docker settings
- [ ] Install DBeaver Community Edition
- [ ] Install Google Cloud CLI (gcloud)
  - [ ] Run `gcloud init` to authenticate
- [ ] Install Google Cloud SQL Proxy (if needed)
- [ ] Verify all tools working

### 7. Additional Software & Utilities
- [ ] Install Bitwarden password manager
  - 📖 [Installation Guide](docs/installation/additional-software.md)
  - [ ] Create account or sign in
  - [ ] **Enable 2FA** (recommended)
  - [ ] Install browser extension
- [ ] Install ComicShannsMono Nerd Font
  - [ ] Download from Nerd Fonts website
  - [ ] Install fonts for current user
  - [ ] Configure in VS Code and Terminal
- [ ] Install Cyohash (file hash calculator)
  - [ ] Or use 7-Zip (already installed) for hash calculation
- [ ] Install Garmin Express (if using Garmin devices)
- [ ] Install WhatsApp Desktop (Microsoft Store - preferred)
  - [ ] Link to phone via QR code
- [ ] Install MariaDB (if needed)
  - [ ] Set root password (save in Bitwarden!)
  - [ ] Verify service running
- [ ] Install Remote Desktop Manager Free
  - [ ] Create data source (SQLite recommended)
  - [ ] Add remote connections

### 8. VPN Clients
- [ ] Install FortiClient VPN (primary)
  - 📖 [Installation Guide](docs/installation/fortinet-vpn.md)
  - [ ] Configure VPN profile with client details
  - [ ] Test VPN connection
  - [ ] Configure auto-connect (optional)
- [ ] Install OpenVPN (if needed for other clients)
  - 📖 [Installation Guide](docs/installation/openvpn.md)
  - [ ] Import .ovpn configuration file
  - [ ] Test connection

### 9. Active Directory Domain Join
- [ ] **PREREQUISITE**: Connect to VPN first!
  - 📖 [Configuration Guide](docs/configuration/domain-join.md)
- [ ] Join laptop to domain: `DOMAIN_NAME`
  - [ ] Use domain admin credentials for join
  - [ ] Restart computer
- [ ] Log in with domain credentials: `DOMAIN_NAME\DOMAIN_USER`
- [ ] Verify domain connection
- [ ] Verify group policies applied

### 10. SQL Server 2025
- [ ] Download SQL Server 2025 Developer Edition
  - 📖 [Installation Guide](docs/installation/sql-server-2025.md)
- [ ] Run SQL Server installation
  - [ ] **Database Engine** (default instance MSSQLSERVER)
  - [ ] **Analysis Services** (Tabular mode)
  - [ ] **Integration Services**
- [ ] Configure mixed mode authentication
  - [ ] Set `sa` password (save in Bitwarden!)
  - [ ] Add Windows admin user
- [ ] Configure services (NT Service virtual accounts)
- [ ] Post-installation configuration:
  - [ ] Enable TCP/IP protocol
  - [ ] Configure firewall (ports 1433, 2383)
  - [ ] Set max memory (recommend 24GB on 32GB system)
  - [ ] Verify services running
- [ ] Apply latest Cumulative Update
  - [ ] Backup system databases first
  - [ ] Download latest CU
  - [ ] Install CU
  - [ ] Verify version after update

### 11. SQL Server Management Studio (SSMS)
- [ ] Download and install SSMS
  - 📖 [Installation Guide](docs/installation/ssms.md)
- [ ] Launch SSMS
- [ ] Connect to Database Engine (localhost or MIRZAKHANI)
- [ ] Connect to Analysis Services (localhost or MIRZAKHANI)
- [ ] Connect to Integration Services (localhost or MIRZAKHANI)
- [ ] Configure SSMS settings:
  - [ ] Enable line numbers
  - [ ] Configure IntelliSense
  - [ ] Set auto-save options
- [ ] Create test query and execute
- [ ] Verify Object Explorer shows all objects

### 12. Visual Studio Community 2019
- [ ] Download Visual Studio 2019 installer
  - 📖 [Installation Guide](docs/installation/visual-studio-2019.md)
- [ ] Run installer
- [ ] Select workload: **Data storage and processing**
- [ ] Install SSIS, SSRS, SSAS extensions
- [ ] Wait for installation (30-60 minutes)
- [ ] Launch Visual Studio 2019
- [ ] Sign in with Microsoft account
- [ ] Test project creation:
  - [ ] Create Integration Services Project (SSIS)
  - [ ] Create Report Server Project (SSRS)
  - [ ] Create Analysis Services Tabular Project (SSAS)
- [ ] Configure extensions and settings

### 13. Visual Studio Community 2026
- [ ] Download Visual Studio 2026 installer
  - 📖 [Installation Guide](docs/installation/visual-studio-2026.md)
- [ ] Run installer
- [ ] Select workloads:
  - [ ] ASP.NET and web development
  - [ ] Azure and AI development
  - [ ] Node.js development
  - [ ] Data storage and processing
  - [ ] Data science and analytical applications
- [ ] Wait for installation (60-120 minutes)
- [ ] Launch Visual Studio 2026
- [ ] Sign in with Microsoft account
- [ ] Test project creation:
  - [ ] ASP.NET Core Web App
  - [ ] Azure Function
  - [ ] Node.js project
  - [ ] Python project
- [ ] Configure Python, Azure, Node.js settings
- [ ] Verify coexistence with VS 2019

### 14. Power BI Report Server
- [ ] Download Power BI Report Server
  - 📖 [Installation Guide](docs/installation/power-bi-report-server.md)
- [ ] Run installer
- [ ] Configure Report Server:
  - [ ] Create ReportServer and ReportServerTempDB databases
  - [ ] Configure web portal URL
  - [ ] Configure web service URL
- [ ] **CRITICAL**: Backup encryption keys!
- [ ] Verify web portal accessible: `http://localhost/Reports`
- [ ] Download and install Power BI Desktop for Report Server
- [ ] Test report creation and publishing

### 15. Power BI Desktop (Standard Version)
- [ ] Install Power BI Desktop
  - 📖 [Installation Guide](docs/installation/power-bi-desktop.md)
- [ ] **Recommended**: Install from Microsoft Store (auto-updates)
- [ ] Or download from Power BI website
- [ ] Launch Power BI Desktop
- [ ] Sign in with Microsoft account
- [ ] Create test report with sample data
- [ ] Connect to SQL Server database
- [ ] Test publishing to Power BI Service (if have license)
- [ ] Verify coexistence with Power BI Desktop for Report Server

### 16. Azure Data Studio (Optional)
- [ ] Download and install Azure Data Studio
  - 📖 [Installation Guide](docs/installation/azure-data-studio.md)
- [ ] Launch Azure Data Studio
- [ ] Connect to SQL Server
- [ ] Install essential extensions:
  - [ ] SQL Server Schema Compare
  - [ ] SQL Server dacpac
  - [ ] Admin Pack for SQL Server
- [ ] Create and run SQL Notebook
- [ ] Configure settings and preferences
- [ ] Test IntelliSense and query execution

### 17. Additional BI Tools (Optional)
- [ ] Install DAX Studio
  - 📖 [Installation Guide](docs/installation/dax-studio.md) *(to be created)*
- [ ] Install Tabular Editor
  - 📖 [Installation Guide](docs/installation/tabular-editor.md) *(to be created)*
- [ ] Install Power BI Report Builder
  - 📖 [Installation Guide](docs/installation/power-bi-report-builder.md) *(to be created)*
- [ ] Install GitHub Desktop
  - 📖 [Installation Guide](docs/installation/github-desktop.md) *(to be created)*

### 18. Final Configuration & Verification
- [ ] Configure VS Code settings and extensions
- [ ] Configure terminal (Windows Terminal or PowerShell) with Nerd Font
- [ ] Set up Git global configuration:
  ```powershell
  git config --global user.name "Your Name"
  git config --global user.email "your.email@example.com"
  ```
- [ ] Configure SSH keys for Git (if using SSH)
- [ ] Test all database connections from all tools
- [ ] Verify all services running:
  - [ ] SQL Server Database Engine
  - [ ] SQL Server Analysis Services
  - [ ] SQL Server Integration Services
  - [ ] Power BI Report Server
  - [ ] MariaDB (if installed)
  - [ ] Docker Desktop
- [ ] Create system restore point
- [ ] Document any deviations or customizations
- [ ] Review [Periodic Updates Guide](docs/configuration/periodic-updates.md)
- [ ] Set monthly update reminder

---

## 📝 Post-Installation Notes

### Installed Software Summary
- [ ] Document all installed software versions
- [ ] Note any installation issues encountered
- [ ] Record any custom configurations
- [ ] Save any license keys used (in Bitwarden)

### Environment Variables
- [ ] Verify `.env` file configured correctly
- [ ] Document any additional environment variables needed

### Client-Specific Customizations
- [ ] Document client-specific settings
- [ ] Note any client-required software not in this checklist
- [ ] Record network/VPN configurations

---

## 🔄 Monthly Maintenance Setup

- [ ] Review [Periodic Updates Guide](docs/configuration/periodic-updates.md)
- [ ] Set calendar reminder for monthly updates (first week of month)
- [ ] Bookmark update resources:
  - Dell SupportAssist
  - Windows Update
  - Microsoft Store
  - Ninite (re-run installer)
  - SSMS update check
  - Power BI Desktop updates

---

## ✅ Installation Complete!

- [ ] **Final Check**: All checkboxes above completed
- [ ] **Final Test**: Can access databases, create reports, run development projects
- [ ] **Backup**: Create full system backup or restore point
- [ ] **Documentation**: File this checklist for reference

**Installation completed on**: __________________

**Total installation time**: __________________

**Notes/Issues**: 
_[Add any notes, issues encountered, or customizations made]_

---

**Template Version**: 1.0  
**Last Updated**: May 27, 2026  
**For**: Dell XPS 13 9310 (MIRZAKHANI)
