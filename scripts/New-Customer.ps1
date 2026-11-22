<#
.SYNOPSIS
    Creates the folder structure and the customer card (README.md) for a new workspace.

.DESCRIPTION
    Implements the layout described in docs/configuration/workspace-structure.md:

        <Root>\<Customer>\                    (direct customer)
        <Root>\<SoftwareHouse>\<Customer>\    (end customer of a software house)

    Each workspace gets the four standard folders (repos, docker, documents, backups)
    with their sub-folders, plus a README.md "customer card" (see section 3.2 of the doc).

    The script asks for every value that was not passed as a parameter.

    Safe by design:
      - It never deletes anything and never overwrites existing folders.
      - If the workspace already exists, only the missing sub-folders are added.
      - An existing README.md is overwritten only after an explicit confirmation.
      - It does NOT read or modify any .gitconfig or SSH file. For direct customers it only
        PRINTS a suggested includeIf snippet that you can paste manually.

.PARAMETER Root
    Root of all workspaces. Defaults to C:\Work.

.PARAMETER Type
    Direct       = a customer you invoice directly (top-level folder).
    EndCustomer  = a customer of a software house (folder inside the software house's folder).

.PARAMETER Name
    Folder name: PascalCase, no spaces, no accents (e.g. CesiMultimedia, A2A, FraternitaSistemi).

.PARAMETER Parent
    EndCustomer only. Folder name of the software house (e.g. CodicePlastico).

.PARAMETER DisplayName
    Human-readable name used as the README title (e.g. "Cesi Multimedia").

.PARAMETER GitEmail
    E-mail used for commits in this workspace (informational: written in the card).

.PARAMETER GitHost
    Git host and account/alias, e.g. github.com-metra or ssh.dev.azure.com.

.PARAMETER GitOrganisation
    Organisation/project on the Git host.

.PARAMETER Vpn
    VPN profile name, if any.

.PARAMETER SqlPort
    Host port for SQL Server containers of this workspace. If omitted, the script proposes
    the next free port after the ones already written in the other customer cards.

.PARAMETER Contacts
    Main contact(s): name, role, e-mail.

.PARAMETER Notes
    Anything non-obvious (retention limits, NDA constraints, ...).

.PARAMETER Yes
    Skips the final "create?" confirmation (useful for scripted runs).

.EXAMPLE
    .\New-Customer.ps1
    Asks everything interactively.

.EXAMPLE
    .\New-Customer.ps1 -Type EndCustomer -Parent CodicePlastico -Name Berg -WhatIf
    Shows what would be created for Berg without touching the disk.

.NOTES
    Author: Work Laptop Setup Repository
    Version: 1.0
    Requires: PowerShell 5.1 or later (tested logic is PowerShell 7 friendly)
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$Root = 'C:\Work',
    [ValidateSet('Direct', 'EndCustomer')]
    [string]$Type,
    [string]$Name,
    [string]$Parent,
    [string]$DisplayName,
    [string]$GitEmail,
    [string]$GitHost,
    [string]$GitOrganisation,
    [string]$Vpn,
    [int]$SqlPort,
    [string]$Contacts,
    [string]$Notes,
    [switch]$Yes
)

$ErrorActionPreference = 'Stop'

# ----------------------------------------------------------------------------
# Layout (keep in sync with docs/configuration/workspace-structure.md, section 3.1)
# ----------------------------------------------------------------------------
$WorkspaceFolders = @(
    'repos'
    'docker'
    'documents\inbox'
    'documents\ingestion'
    'documents\exports'
    'documents\deliverables'
    'documents\specs'
    'backups\sqlserver'
    'backups\bacpac'
    'backups\docker-volumes'
)
$SharedFolders = @('_shared\repos', '_shared\documents')
$FirstFreePort = 14331   # 14330 is reserved for the own workspace (1729)

# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------
function Read-Value {
    param(
        [string]$Prompt,
        [string]$Current,
        [bool]$Supplied = $false,
        [string]$Default = '',
        [switch]$Required
    )
    if ($Supplied -or $Current) { return "$Current".Trim() }
    while ($true) {
        $suffix = if ($Default) { " [$Default]" } else { '' }
        $answer = "$(Read-Host "$Prompt$suffix")".Trim()
        if (-not $answer) { $answer = $Default }
        if ($answer -or -not $Required) { return $answer }
        Write-Host '  A value is required.' -ForegroundColor Yellow
    }
}

function Read-YesNo {
    param([string]$Prompt, [bool]$Default = $true)
    $hint = if ($Default) { 'Y/n' } else { 'y/N' }
    $answer = "$(Read-Host "$Prompt ($hint)")".Trim()
    if (-not $answer) { return $Default }
    return $answer -match '^(y|yes|s|si)$'
}

function Assert-FolderName {
    param([string]$Value, [string]$What)
    if ($Value -notmatch '^[A-Za-z0-9]+$') {
        throw "$What '$Value' is not valid: use letters and digits only (PascalCase, no spaces, no accents)."
    }
}

function Get-UsedSqlPorts {
    param([string]$RootPath)
    # Cards live at <Root>\<Customer>\README.md and <Root>\<SoftwareHouse>\<Customer>\README.md
    $patterns = @((Join-Path $RootPath '*\README.md'), (Join-Path $RootPath '*\*\README.md'))
    $ports = @{}
    foreach ($card in (Get-ChildItem -Path $patterns -File -ErrorAction SilentlyContinue)) {
        $m = Select-String -Path $card.FullName -Pattern '^-\s*SQL Server containers:\s*host port\s*(\d+)' |
             Select-Object -First 1
        if ($m) { $ports[[int]$m.Matches[0].Groups[1].Value] = $card.DirectoryName }
    }
    return $ports
}

function Get-CardValue {
    param([string]$CardPath, [string]$Label)
    if (-not (Test-Path -LiteralPath $CardPath)) { return '' }
    $m = Select-String -LiteralPath $CardPath -Pattern ('^-\s*' + [regex]::Escape($Label) + ':\s*(\S+)') |
         Select-Object -First 1
    if ($m) { return $m.Matches[0].Groups[1].Value }
    return ''
}

function New-Folder {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) { return $false }
    if ($PSCmdlet.ShouldProcess($Path, 'Create folder')) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
    return $true
}

# ----------------------------------------------------------------------------
# 1. Root
# ----------------------------------------------------------------------------
if (-not (Test-Path -LiteralPath $Root)) {
    if ($Yes -or (Read-YesNo "Root folder '$Root' does not exist. Create it?")) {
        New-Folder $Root | Out-Null
    }
    else {
        Write-Host 'Operation cancelled.' -ForegroundColor Yellow
        return
    }
}

# ----------------------------------------------------------------------------
# 2. Questions
# ----------------------------------------------------------------------------
Write-Host ''
Write-Host 'New customer workspace' -ForegroundColor Cyan
Write-Host '----------------------' -ForegroundColor Cyan

if (-not $Type) {
    Write-Host '  1) Direct customer (you invoice them)'
    Write-Host '  2) End customer of a software house (e.g. a CodicePlastico customer)'
    do { $choice = "$(Read-Host 'Type [1/2]')".Trim() } until ($choice -in '1', '2')
    $Type = if ($choice -eq '1') { 'Direct' } else { 'EndCustomer' }
}

$Name = Read-Value -Prompt 'Folder name (PascalCase, no spaces/accents, e.g. CesiMultimedia)' -Current $Name -Required
Assert-FolderName $Name 'Folder name'

if ($Type -eq 'EndCustomer') {
    $Parent = Read-Value -Prompt 'Software house folder name' -Current $Parent -Default 'CodicePlastico' -Required
    Assert-FolderName $Parent 'Software house folder name'
    $parentPath    = Join-Path $Root $Parent
    $workspacePath = Join-Path $parentPath $Name
    $billingEntity = $Parent
}
else {
    $parentPath    = $null
    $workspacePath = Join-Path $Root $Name
    $billingEntity = $Name
}

$defaultDisplay = ($Name -creplace '(?<=[a-z])(?=[A-Z])', ' ')
$DisplayName = Read-Value -Prompt 'Display name (README title)' -Current $DisplayName -Default $defaultDisplay -Required

# Git identity: for end customers, propose the one written in the software house card (if any)
$defaultEmail = ''
if ($Type -eq 'EndCustomer') {
    $defaultEmail = Get-CardValue -CardPath (Join-Path $parentPath 'README.md') -Label 'Git identity'
}
$GitEmail = Read-Value -Prompt 'Git identity (commit e-mail)' -Current $GitEmail -Supplied $PSBoundParameters.ContainsKey('GitEmail') -Default $defaultEmail
$GitHost  = Read-Value -Prompt 'Git host / SSH alias (e.g. github.com-metra)' -Current $GitHost -Supplied $PSBoundParameters.ContainsKey('GitHost')
$GitOrganisation = Read-Value -Prompt 'Git organisation / project' -Current $GitOrganisation -Supplied $PSBoundParameters.ContainsKey('GitOrganisation')
$Vpn      = Read-Value -Prompt 'VPN profile (empty = none)' -Current $Vpn -Supplied $PSBoundParameters.ContainsKey('Vpn')

# SQL port: propose the next free one, warn on duplicates
$usedPorts = Get-UsedSqlPorts -RootPath $Root
$suggested = $FirstFreePort
if ($usedPorts.Count -gt 0) {
    $suggested = [Math]::Max($FirstFreePort, (($usedPorts.Keys | Measure-Object -Maximum).Maximum + 1))
}
$portText = Read-Value -Prompt 'SQL Server host port' -Current $(if ($SqlPort) { "$SqlPort" } else { '' }) -Default "$suggested" -Required
if ($portText -notmatch '^\d+$' -or [int]$portText -lt 1 -or [int]$portText -gt 65535) {
    throw "Invalid port '$portText'."
}
$SqlPort = [int]$portText
if ($usedPorts.ContainsKey($SqlPort)) {
    Write-Warning "Port $SqlPort is already used by the card in $($usedPorts[$SqlPort])."
    if (-not (Read-YesNo 'Use it anyway?' $false)) {
        Write-Host 'Operation cancelled.' -ForegroundColor Yellow
        return
    }
}

$Contacts = Read-Value -Prompt 'Main contact (name, role, e-mail; empty = fill in later)' -Current $Contacts -Supplied $PSBoundParameters.ContainsKey('Contacts')
$Notes    = Read-Value -Prompt 'Notes (retention, NDA, ...; empty = none)' -Current $Notes -Supplied $PSBoundParameters.ContainsKey('Notes')

# ----------------------------------------------------------------------------
# 3. Summary and confirmation
# ----------------------------------------------------------------------------
$parentIsNew   = ($Type -eq 'EndCustomer') -and -not (Test-Path -LiteralPath $parentPath)
$workspaceIsNew = -not (Test-Path -LiteralPath $workspacePath)

Write-Host ''
Write-Host 'Summary' -ForegroundColor Cyan
Write-Host "  Workspace : $workspacePath$(if (-not $workspaceIsNew) { '  (exists: only missing folders will be added)' })"
if ($parentIsNew) {
    Write-Host "  Parent    : $parentPath  (will be created with _shared\)" -ForegroundColor Yellow
}
Write-Host "  Billing   : $billingEntity"
Write-Host "  Git       : $(if ($GitEmail) { $GitEmail } else { '<empty>' })"
Write-Host "  SQL port  : $SqlPort"
Write-Host ''

if (-not $Yes -and -not $WhatIfPreference) {
    if (-not (Read-YesNo 'Create it?')) {
        Write-Host 'Operation cancelled.' -ForegroundColor Yellow
        return
    }
}

# ----------------------------------------------------------------------------
# 4. Folders
# ----------------------------------------------------------------------------
$created = New-Object System.Collections.Generic.List[string]

if ($parentIsNew) {
    New-Folder $parentPath | Out-Null
    foreach ($rel in $SharedFolders) {
        if (New-Folder (Join-Path $parentPath $rel)) { $created.Add((Join-Path $parentPath $rel)) }
    }
}

New-Folder $workspacePath | Out-Null
foreach ($rel in $WorkspaceFolders) {
    $full = Join-Path $workspacePath $rel
    if (New-Folder $full) { $created.Add($full) }
}

# ----------------------------------------------------------------------------
# 5. Customer card
# ----------------------------------------------------------------------------
if ($Type -eq 'EndCustomer') {
    $billingLine  = "- Billing entity: $Parent (software house); end customer: $DisplayName"
    $invoicesLine = "- Drive invoices folder: Invoices\<year>\Issued\$Parent (one invoice); timesheets in Invoices\<year>\Issued\$Parent\Timesheets\$Name"
}
else {
    $billingLine  = "- Billing entity: $DisplayName (direct)"
    $invoicesLine = "- Drive invoices folder: Invoices\<year>\Issued\$Name"
}

$gitIdentityText = if ($GitEmail) { $GitEmail } else { '<to be filled in>' }
$gitHostText     = if ($GitHost -or $GitOrganisation) {
    "$(if ($GitHost) { $GitHost } else { '<host>' }), organisation $(if ($GitOrganisation) { $GitOrganisation } else { '<...>' })"
} else { '<GitHub / Azure DevOps / GitLab>, organisation <...>' }
$vpnText      = if ($Vpn) { $Vpn } else { 'none' }
$contactsText = if ($Contacts) { $Contacts } else { '<name, role, e-mail>' }
$notesText    = if ($Notes) { $Notes } else { '<anything non-obvious, e.g. data retention limits, NDA constraints>' }

$card = @"
# $DisplayName

$billingLine
- Git identity: $gitIdentityText  (applied automatically by the includeIf rule in your .gitconfig)
- Git host: $gitHostText
- VPN: $vpnText
- SQL Server containers: host port $SqlPort
$invoicesLine
- NAS sync: weekly (included)
- Contacts: $contactsText
- Notes: $notesText
"@

$cardPath = Join-Path $workspacePath 'README.md'
$writeCard = $true
if (Test-Path -LiteralPath $cardPath) {
    $writeCard = (-not $WhatIfPreference) -and (Read-YesNo "README.md already exists in $workspacePath. Overwrite?" $false)
}
if ($writeCard -and $PSCmdlet.ShouldProcess($cardPath, 'Write customer card')) {
    [System.IO.File]::WriteAllText($cardPath, $card + [Environment]::NewLine, (New-Object System.Text.UTF8Encoding($false)))
    $created.Add($cardPath)
}

# ----------------------------------------------------------------------------
# 6. Result and next steps (nothing below modifies the system)
# ----------------------------------------------------------------------------
Write-Host ''
if ($created.Count -gt 0) {
    Write-Host "Created $($created.Count) item(s):" -ForegroundColor Green
    $created | ForEach-Object { Write-Host "  $_" }
}
else {
    Write-Host 'Nothing to create: everything already exists.' -ForegroundColor Yellow
}

Write-Host ''
Write-Host 'Next steps (manual):' -ForegroundColor Yellow
Write-Host "  1. Move the existing data into $workspacePath\repos, \documents, \backups."
Write-Host "  2. Google Drive: create $(if ($Type -eq 'EndCustomer') { "Invoices\<year>\Issued\$Parent\Timesheets\$Name" } else { "Invoices\<year>\Issued\$Name" })."
Write-Host '  3. Add the workspace to your NAS sync manifest, if you keep one.'

if ($Type -eq 'Direct') {
    $unixRoot = ($workspacePath -replace '\\', '/')
    $wslRoot  = if ($workspacePath -match '^([A-Za-z]):(.*)$') { '/mnt/' + $Matches[1].ToLower() + ($Matches[2] -replace '\\', '/') } else { $null }
    Write-Host ''
    Write-Host '  4. Git identity: this script did NOT touch your .gitconfig. If this customer needs'
    Write-Host '     a different e-mail than your default, a possible rule is:' -ForegroundColor DarkGray
    Write-Host ''
    Write-Host "     [includeIf `"gitdir/i:$unixRoot/`"]" -ForegroundColor DarkGray
    Write-Host '         path = <your include file with [user] email = ...>' -ForegroundColor DarkGray
    if ($wslRoot) {
        Write-Host "     [includeIf `"gitdir/i:$wslRoot/`"]    ; same rule seen from WSL" -ForegroundColor DarkGray
        Write-Host '         path = <your include file with [user] email = ...>' -ForegroundColor DarkGray
    }
}
else {
    Write-Host '  4. Git identity: inherited from the includeIf rule on the software house folder (nothing to do).'
}
Write-Host ''
