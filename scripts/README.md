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
- **Sync-Work.ps1** - Weekly backup of `C:\Work` to `\\NAS-1729\Work\Git`, keeping the same folder structure: Git repositories (any folder with a `.git`) are exported as bare mirrors with `git push --mirror` (`<repo>.git`), everything else is copied with `robocopy /E` (nothing is ever deleted on the NAS). It writes only to the `Git` folder (`_old` and `_Archive` are never touched), skips `docker_volumes` and `node_modules`, retries when the NAS is unreachable, allows a single instance at a time and logs to `%LOCALAPPDATA%\Sync-Work\logs`. Use `-WhatIf` for a dry run and `-RegisterTask` to create the weekly Scheduled Task. Full details, first-run procedure and restore: [Workspace Structure, section 7](../docs/configuration/workspace-structure.md#7-weekly-nas-sync).

  ```powershell
  .\Sync-Work.ps1 -WhatIf          # dry run, nothing is written to the NAS
  .\Sync-Work.ps1                  # run now
  .\Sync-Work.ps1 -RegisterTask    # every Sunday at 12:00 (-TaskDay, -TaskTime to change)
  ```
- **Backup-Monthly.ps1** - Monthly backup of what lives outside `C:\Work`, into one dated folder (`C:\Work\1729\backups\monthly\<yyyy-MM>`, so the weekly NAS sync carries it away): Bitwarden vault (encrypted export through the `bw` CLI), `.ssh` and `.git*` (AES-256 zip, needs 7-Zip), Edge favorites, Remote Desktop Manager data, SSMS settings, Desktop, the WSL home folder (`.tar.gz`), Windows Terminal settings, SQL Prompt snippets and styles, and the hosts file. Items are independent (a missing application is skipped, a failure does not stop the others) and the run ends with an OK / SKIPPED / FAILED table. Bitwarden and SSH/Git are never written unencrypted: without the backup password they are skipped. Archives are written to `.partial` files and verified before being renamed; nothing is ever deleted. It is run by hand because it asks for passwords; `-Skip Bitwarden,SshGit` makes it unattended. Logs go to `%LOCALAPPDATA%\Backup-Monthly\logs`. Full details, what is not covered and restore: [Periodic Updates, Monthly Backup](../docs/configuration/periodic-updates.md#-monthly-backup-of-personal-settings-and-data).

  ```powershell
  .\Backup-Monthly.ps1 -WhatIf                     # dry run, nothing is written
  .\Backup-Monthly.ps1                             # full backup
  .\Backup-Monthly.ps1 -Skip Bitwarden,SshGit      # without the password prompts
  .\Backup-Monthly.ps1 -Only WslHome -WslExclude '.cache','node_modules'
  ```
