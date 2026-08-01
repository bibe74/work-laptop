<#
.SYNOPSIS
    Creates a new dated installation checklist from the template.

.DESCRIPTION
    This script copies INSTALL-template.md to a new file named INSTALL-YYYYMMDD.md
    where YYYYMMDD is the current date. This allows you to work on a dated checklist
    while keeping the template unchanged for future use.

.PARAMETER OutputPath
    Optional. The directory where the dated checklist will be created.
    Defaults to the repository root directory.

.EXAMPLE
    .\New-InstallationChecklist.ps1
    Creates INSTALL-20260527.md in the repository root.

.EXAMPLE
    .\New-InstallationChecklist.ps1 -OutputPath "C:\Temp"
    Creates INSTALL-20260527.md in C:\Temp directory.

.NOTES
    Author: Work Laptop Setup Repository
    Version: 1.0
    Created: May 27, 2026
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$OutputPath
)

# Get the script directory (repository root)
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptPath

# Set output path to repo root if not specified
if (-not $OutputPath) {
    $OutputPath = $repoRoot
}

# Template file path
$templateFile = Join-Path -Path $repoRoot -ChildPath "INSTALL-template.md"

# Check if template exists
if (-not (Test-Path $templateFile)) {
    Write-Error "Template file not found: $templateFile"
    Write-Error "Please ensure INSTALL-template.md exists in the repository root."
    exit 1
}

# Generate filename with current date (YYYYMMDD format)
$currentDate = Get-Date -Format "yyyyMMdd"
$newFileName = "INSTALL-$currentDate.md"
$newFilePath = Join-Path -Path $OutputPath -ChildPath $newFileName

# Check if file already exists
if (Test-Path $newFilePath) {
    $response = Read-Host "File $newFileName already exists. Overwrite? (Y/N)"
    if ($response -ne 'Y' -and $response -ne 'y') {
        Write-Host "Operation cancelled." -ForegroundColor Yellow
        exit 0
    }
}

# Copy template to new dated file
try {
    Copy-Item -Path $templateFile -Destination $newFilePath -Force
    Write-Host "✅ Installation checklist created successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "File: $newFilePath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📋 Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Open the file: $newFileName"
    Write-Host "  2. Fill in the 'Installation Date' at the top"
    Write-Host "  3. Check off items as you complete them"
    Write-Host "  4. Add notes/issues at the bottom as needed"
    Write-Host ""
    Write-Host "💡 Tip: The template (INSTALL-template.md) remains unchanged for future use." -ForegroundColor Cyan
    Write-Host ""
    
    # Ask if user wants to open the file
    $openFile = Read-Host "Would you like to open the checklist now? (Y/N)"
    if ($openFile -eq 'Y' -or $openFile -eq 'y') {
        # Try to open with default markdown editor (usually VS Code)
        Start-Process $newFilePath
    }
}
catch {
    Write-Error "Failed to create installation checklist: $_"
    exit 1
}
