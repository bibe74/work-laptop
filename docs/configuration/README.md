# Configuration Guides

This folder contains guides for configuring Windows, system settings, and software after installation.

## Configuration Areas

### System Configuration
- Windows 11 settings and optimizations
- Environment variables
- System paths
- Windows features (Hyper-V, WSL, etc.)

### Maintenance & Updates
- [Periodic Updates Guide](periodic-updates.md) ✅ Created
  - Comprehensive update procedures for all software
  - Dell firmware and BIOS updates via SupportAssist
  - Monthly checklist
  - Monthly backup of personal settings and data (Bitwarden, SSH/Git, Edge, RDM, SSMS, Desktop, WSL home, Windows Terminal, SQL Prompt, hosts) with `scripts\Backup-Monthly.ps1`
  - Troubleshooting update issues

### Network & Domain
- [Active Directory Domain Join](domain-join.md) ✅ Created
- VPN configuration and auto-connect
- Network drives and printer mapping

### Workspace & Workflow
- [Workspace Structure](workspace-structure.md) ✅ Created
  - Directory layout for customers, repositories, Docker stacks, documents and backups
  - Git identity per customer, weekly NAS sync, invoices on Google Drive
  - Weekly backup of `C:\Work` to the NAS with `scripts\Sync-Work.ps1` (section 7)

### Development Environment
- Visual Studio settings and extensions
- VS Code settings and extensions
- Git configuration
- PowerShell profile and modules

### BI Tools Configuration
- SQL Server instance configuration
- SSMS preferences and shortcuts
- Power BI Desktop settings
- Azure Data Studio configuration

### Security & Access
- Firewall rules
- SQL Server authentication
- SSL certificates
- Service accounts

## Configuration Files

This folder may also contain:
- Sample configuration files (.json, .xml, .config)
- Settings export files
- Templates for common configurations
