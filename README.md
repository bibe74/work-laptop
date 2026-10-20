# Work Laptop Setup Guide

## 🎯 Purpose

This repository serves as a comprehensive, living documentation for setting up and configuring a complete Business Intelligence development environment on Windows 11. It's designed to streamline the process of preparing a new workstation or reinstalling an existing one, ensuring consistency, completeness, and efficiency in environment setup.

As a freelance BI Architect and Developer working with multiple clients—both directly and through software houses—maintaining a standardized, reliable, and well-documented development environment is critical. This guide eliminates guesswork and ensures that all necessary tools, configurations, and optimizations are in place.

## � Hardware Specifications

**Laptop**: Dell XPS 13 9310  
**Computer Name**: MIRZAKHANI  
**RAM**: 32 GB  
**Storage**: 1 TB SSD  
**OS**: Windows 11

## �👤 About This Guide

This is a personal setup guide tailored for **Microsoft Stack BI Development**, including:

- **SQL Server** (Database Engine, Integration Services, Analysis Services, Reporting Services)
- **Power BI** (Desktop, Report Builder, and related tools)
- **Development Tools** (Visual Studio, VS Code, SQL Server Management Studio, etc.)
- **Supporting Software** (Git, productivity tools, utilities, etc.)

While designed for personal use, this guide may be valuable to other BI professionals working in similar technology stacks.

## 📋 What This Repository Contains

This repository will include:

1. **Installation Guides**: Step-by-step instructions for installing each software component
2. **Configuration Instructions**: Post-installation configurations, settings, and optimizations
3. **Environment Setup**: System settings, environment variables, and Windows configurations
4. **Tool Integrations**: How to connect and integrate various tools in the stack
5. **Troubleshooting**: Common issues and their resolutions
6. **Version Information**: Specific versions and compatibility notes
7. **Best Practices**: Recommended settings and workflows

## 🏗️ Technology Stack Overview

### Core BI Platform
- Microsoft SQL Server 2025 (Database Engine, SSIS, SSAS Tabular)
- SQL Server Management Studio (SSMS)
- Power BI Report Server (on-premises reporting)
- Power BI Desktop (standard version for cloud)
- Power BI Desktop for Report Server (on-premises version)
- Azure Data Studio
- DAX Studio, Tabular Editor (BI utilities)

### Development Tools
- Visual Studio Community 2026 (ASP.NET, Azure/AI, Node.js, Data storage, Data science)
- Visual Studio Community 2019 (Legacy BI projects - SSIS, SSRS, SSAS)
- Visual Studio Code (via Ninite)
- Git & GitHub Desktop
- PowerShell 7 (Microsoft Store)
- Windows Subsystem for Linux (WSL)
- Docker Desktop (integrated with WSL)
- DBeaver Community Edition

### Cloud Tools
- Google Cloud CLI (gcloud)
- Google Cloud SQL Proxy

### Core Utilities (Managed via Ninite)
- Google Chrome - Web browser
- 7-Zip - File compression
- Git - Version control
- Notepad++ - Text editor
- Visual Studio Code - Code editor
- Foxit Reader - PDF viewer
- Google Drive for Desktop - Cloud storage
- iTunes - Media library

### Productivity & Communication
- Office 365 (Word, Excel, PowerPoint, Outlook)
- Microsoft Teams
- Slack
- WhatsApp Desktop

### VPN & Network Access
- FortiClient VPN (primary VPN client)
- OpenVPN (alternative VPN client)
- Remote Desktop Manager Free

### Security & Utilities
- Bitwarden (password manager)
- Cyohash (file hash/checksum calculator)
- 7-Zip (includes hash calculation via CRC SHA)
- Dell SupportAssist for Business PCs (firmware and driver updates)

### Databases
- Microsoft SQL Server 2025
- MariaDB

### Personal & Fitness
- Garmin Express (device management)
- iTunes (via Ninite)

### Fonts & Customization
- ComicShannsMono Nerd Font (programming font)

*(Specific versions and additional tools will be documented in dedicated installation guides)*

## 📁 Repository Structure

```
work-laptop/
├── README.md                          # This file - project overview
├── INSTALL-template.md                # Installation checklist template
├── INSTALL-Ubuntu.md                  # Ubuntu 26.10 setup for Dell XPS 13
├── .env.sample                        # Environment variables template
├── .gitignore                         # Git ignore rules
├── docs/                              # Detailed documentation
│   ├── installation/                  # Installation guides
│   │   ├── README.md                  # Installation guides index
│   │   ├── windows-11-fresh-install.md
│   │   ├── dell-supportassist.md
│   │   ├── ninite.md
│   │   ├── sql-server-2025.md
│   │   ├── ssms.md
│   │   ├── visual-studio-2019.md
│   │   ├── visual-studio-2026.md
│   │   ├── power-bi-report-server.md
│   │   ├── power-bi-desktop.md
│   │   ├── azure-data-studio.md
│   │   └── ...
│   ├── configuration/                 # Configuration guides
│   │   ├── domain-join.md
│   │   ├── periodic-updates.md
│   │   └── ...
│   ├── troubleshooting/              # Troubleshooting guides
│   └── references/                    # Quick references and checklists
├── scripts/                           # Automation scripts (PowerShell, batch files)
│   ├── New-InstallationChecklist.ps1  # Creates dated checklist from template
│   └── ...
└── resources/                         # Additional resources (configs, templates)
```

### Installation Checklist Workflow

**Template System**:
- `INSTALL-template.md` - Master checklist template (tracked in Git)
- `INSTALL-YYYYMMDD.md` - Dated working copies (ignored by Git)

**Usage**:
1. Run `.\scripts\New-InstallationChecklist.ps1` to create a dated copy
2. Work through your dated checklist, checking off items
3. Add notes and customizations to your dated file
4. Template updates when documentation changes
5. Create new dated checklists for reinstalls or new machines

**Benefits**:
- Track progress on specific installation
- Keep historical records of installations
- Template stays clean for future use
- Easy to see what's been completed

## 🚀 Getting Started

### Prerequisites
- Fresh Windows 11 installation (or clean existing installation)
  - See: [Windows 11 Fresh Install Guide](docs/installation/windows-11-fresh-install.md)
- Administrator access
- Internet connection
- Windows updates completed

### Initial Repository Setup

When you first clone this repository, you need to configure your environment:

1. **Copy the environment template**
   ```powershell
   Copy-Item .env.sample .env
   ```

2. **Edit the `.env` file** with your actual values:
   - `CLIENT_NAME` - The client/company name you're working for (e.g., `CLIENT`)
   - `VPN_NAME` - The name of the client's VPN connection (e.g., `Client VPN`)
   - `DOMAIN_NAME` - Your client's Active Directory domain (e.g., `client.local`)
   - `DOMAIN_USER` - Your domain username (e.g., `user1729`)

3. **Never commit the `.env` file** - It contains client-specific information and is automatically ignored by Git

**Note**: The laptop will connect to the client network via FortiClient VPN, join the client's Active Directory domain, and you'll log in using domain credentials in the format: `DOMAIN_NAME\DOMAIN_USER`

### Using This Guide

1. **Start with System Setup**: Begin with Windows configuration and system-level settings
2. **Follow the Installation Order**: Some tools have dependencies; follow the recommended sequence
3. **Customize as Needed**: Adapt configurations to your specific client requirements
4. **Keep Notes**: Document any deviations or client-specific customizations

### Recommended Installation Order

1. **Windows 11 Fresh Installation** - [Guide](docs/installation/windows-11-fresh-install.md)
2. **Dell SupportAssist for Business PCs** - [Installation Guide](docs/installation/dell-supportassist.md)
3. Windows 11 system configuration and updates
4. **Ninite - Core Utilities & Development Tools** - [Guide](docs/installation/ninite.md)
   - Installs: Chrome, 7-Zip, iTunes, Git, Notepad++, VS Code, Foxit Reader, Google Drive
5. **Office 365, Microsoft Teams & Slack** - [Installation Guide](docs/installation/office-teams-slack.md)
6. **Additional Development Tools** - [Installation Guide](docs/installation/additional-dev-tools.md)
   - PowerShell 7, WSL, Docker Desktop, DBeaver, Google Cloud CLI
7. **Additional Software** - [Installation Guide](docs/installation/additional-software.md)
   - Bitwarden, Fonts, Gyazo, Garmin Express, WhatsApp, MariaDB, Remote Desktop Manager
8. **VPN Clients** - FortiClient and/or OpenVPN
   - [FortiClient VPN](docs/installation/fortinet-vpn.md)
   - [OpenVPN](docs/installation/openvpn.md)
9. **Active Directory Domain Join** - [Configuration Guide](docs/configuration/domain-join.md)
10. **SQL Server 2025** - [Installation Guide](docs/installation/sql-server-2025.md)
    - Database Engine, Analysis Services (Tabular), Integration Services
    - Apply latest Cumulative Update
11. **SQL Server Management Studio (SSMS)** - [Installation Guide](docs/installation/ssms.md)
12. **Visual Studio Community 2019** - [Installation Guide](docs/installation/visual-studio-2019.md)
    - Data storage and processing workload for legacy BI projects (SSIS, SSRS, SSAS)
13. **Visual Studio Community 2026** - [Installation Guide](docs/installation/visual-studio-2026.md)
    - ASP.NET, Azure/AI, Node.js, Data storage, Data science workloads
14. **Power BI Report Server** - [Installation Guide](docs/installation/power-bi-report-server.md)
    - Includes Power BI Desktop for Report Server edition
15. **Power BI Desktop** (standard version) - [Installation Guide](docs/installation/power-bi-desktop.md)
16. Additional BI tools (DAX Studio, Tabular Editor, etc.)
17. Final configurations and optimizations

**Note**: See [Periodic Updates Guide](docs/configuration/periodic-updates.md) for maintaining all software.

**Linux setup path**: For an Ubuntu workstation instead of the Windows setup above, see [Ubuntu 26.10 on a Dell XPS 13](INSTALL-Ubuntu.md).

## 🔄 Maintenance & Updates

This repository is a **living document** that will be updated regularly to reflect:

- New software versions and updates
- Changes in client requirements
- New tools added to the stack
- Deprecated tools or configurations
- Lessons learned and optimizations
- Security updates and patches

### 📅 Periodic Updates

Regular software updates are essential for security, stability, and performance. A comprehensive update routine has been established:

**Complete Update Guide**: [Periodic Updates Documentation](docs/configuration/periodic-updates.md)

This guide includes:
- Step-by-step update procedures for all installed software
- Dell firmware and BIOS updates via SupportAssist
- Windows and Microsoft Store updates
- Core utilities updates via Ninite
- Development tools, database tools, and cloud tools updates
- Monthly update checklist
- Troubleshooting common update issues

**Recommended Schedule**: First week of each month (1-2 hours)

### Regular Maintenance Tasks

**Monthly**: See [Periodic Updates Guide](docs/configuration/periodic-updates.md)
- Dell SupportAssist - firmware and driver updates
- Windows updates
- Ninite - core utilities (Chrome, Git, VS Code, etc.)
- Microsoft Store apps (PowerShell 7, WSL distributions)
- Docker Desktop
- Google Cloud CLI

**Quarterly**:
- SQL Server cumulative updates (review release notes)
- Power BI Desktop
- Review installed software and remove unused applications
- Update PowerShell modules
- Update documentation for workflow changes

**As Needed**:
- Critical security patches
- FortiClient VPN updates
- Update when client requirements change
- Install new tools for specific projects
- Update guides based on lessons learned

### Version Control Philosophy

- Each significant change will be committed with clear descriptions
- Major updates (e.g., SQL Server version upgrades) will be tagged
- Historical configurations will be maintained for reference
- Rollback information will be included where applicable

## 📝 How to Use This Repository

### For a New Laptop Setup

**Quick Start with Installation Checklist**:
1. Clone this repository to your new machine
2. Create a dated installation checklist:
   ```powershell
   .\scripts\New-InstallationChecklist.ps1
   ```
   This creates `INSTALL-YYYYMMDD.md` (e.g., `INSTALL-20260527.md`) from the template
3. Open your dated checklist and work through it step-by-step
4. Check off items as you complete them
5. The template (`INSTALL-template.md`) remains unchanged for future use

**Detailed Setup Process**:
1. Clone this repository to your new machine
2. Review the README for overview and structure
3. Copy `.env.sample` to `.env` and configure client details
4. Follow installation guides in the recommended order:
   - Start with [Windows 11 Fresh Install](docs/installation/windows-11-fresh-install.md)
   - Continue with [Dell SupportAssist](docs/installation/dell-supportassist.md)
   - Then [Ninite](docs/installation/ninite.md) for core utilities
   - Install [Office, Teams, Slack](docs/installation/office-teams-slack.md)
   - Install [Additional Development Tools](docs/installation/additional-dev-tools.md)
   - Install [Additional Software](docs/installation/additional-software.md) (Bitwarden, fonts, utilities)
   - Set up [FortiClient VPN](docs/installation/fortinet-vpn.md) and/or [OpenVPN](docs/installation/openvpn.md)
   - Complete [Domain Join](docs/configuration/domain-join.md)
   - Install [SQL Server 2025](docs/installation/sql-server-2025.md)
   - Install [SSMS](docs/installation/ssms.md)
   - Install [Visual Studio 2019](docs/installation/visual-studio-2019.md) for legacy BI projects
   - Install [Visual Studio 2026](docs/installation/visual-studio-2026.md) for modern development
   - Install [Power BI Report Server](docs/installation/power-bi-report-server.md)
   - Install [Power BI Desktop](docs/installation/power-bi-desktop.md) (standard version)
5. Execute configuration scripts where available
6. Verify installations using provided checklists
7. Set up [monthly update routine](docs/configuration/periodic-updates.md)

### For Existing Environment Updates
1. Review [Periodic Updates Guide](docs/configuration/periodic-updates.md) for monthly maintenance
2. Check specific installation/configuration guides for individual software
3. Review compatibility and dependency notes
4. Follow update procedures in the periodic updates guide
5. Test thoroughly before production use

### For Client-Specific Customizations
1. Create a branch for client-specific variations (if needed)
2. Document any client-specific requirements
3. Maintain separation between general and client configurations

## ✅ Quality Assurance

Each installation and configuration guide should include:

- Clear, step-by-step instructions
- Screenshots or visual aids where helpful
- Verification steps to confirm successful installation
- Common issues and troubleshooting tips
- Version information and compatibility notes
- Links to official documentation

## 🤝 Contributing (Personal Use)

While this is a personal repository, contributions come in the form of:

- Regular updates based on new installations
- Documentation improvements
- Script automation enhancements
- Troubleshooting solutions from real-world issues

## 📚 Additional Resources

- [Microsoft SQL Server Documentation](https://docs.microsoft.com/en-us/sql/)
- [Power BI Documentation](https://docs.microsoft.com/en-us/power-bi/)
- [Visual Studio Documentation](https://docs.microsoft.com/en-us/visualstudio/)
- [Windows 11 Setup & Configuration](https://support.microsoft.com/en-us/windows)

## 📄 License

This is a personal documentation repository. Use at your own discretion.

## 🔖 Notes

- This guide assumes familiarity with Windows systems and BI development
- Always backup data before making system changes
- Test configurations in a safe environment when possible
- Keep software licenses and credentials secure (not in this repository)
- Maintain separate documentation for client-specific credentials and sensitive information

---

**Last Updated**: May 27, 2026  
**Windows Version**: Windows 11  
**Primary Stack**: Microsoft BI Platform (SQL Server, Power BI)

---

*This guide is continuously evolving. Check commit history for recent changes and updates.*
