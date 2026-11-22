# Automation Scripts

This folder contains PowerShell scripts, batch files, and other automation tools to streamline setup and maintenance tasks.

## Script Categories

### Installation Scripts
- Automated software installation using Winget or Chocolatey
- Batch installation of multiple tools
- Silent installation configurations

### Configuration Scripts
- Windows settings automation
- Environment variable setup
- Registry modifications (use with caution)
- Service configuration

### Maintenance Scripts
- Update checks and automation
- Backup configurations
- Cleanup and optimization
- Health checks

### Utility Scripts
- Database backup/restore helpers
- Connection testing
- Environment validation
- Version checking

## Usage Guidelines

⚠️ **Important Safety Notes**:
- Always review scripts before running
- Run with appropriate permissions (may require Administrator)
- Test in a safe environment first
- Back up before running system-modifying scripts
- Keep scripts updated with current software versions

## Execution Policy

You may need to set PowerShell execution policy:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Script Template

Each script should include:
- Header comment with description and author
- Parameter definitions
- Error handling
- Logging
- Rollback capability (where applicable)

## Available Scripts

- **New-InstallationChecklist.ps1** - Creates a dated installation checklist from `INSTALL-template.md`.
- **New-Customer.ps1** - Creates a customer workspace (`repos`, `docker`, `documents`, `backups`) and its `README.md` customer card, as described in [Workspace Structure](../docs/configuration/workspace-structure.md). Interactive; every question can also be passed as a parameter. Use `-WhatIf` to preview. It never deletes or overwrites folders and never modifies `.gitconfig`.
