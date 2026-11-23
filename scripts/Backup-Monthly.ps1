<#
.SYNOPSIS
    Monthly backup of the personal settings and data that are NOT under C:\Work.

.DESCRIPTION
    Implements the "Monthly backup" section of docs/configuration/periodic-updates.md.

    Everything is written to ONE dated folder, <BackupRoot>\<yyyy-MM>, one sub-folder per item:

        Bitwarden\bitwarden-export.json      encrypted export of the vault (needs the Bitwarden CLI)
        SshGit\ssh-git.zip                   AES-256 zip of ~\.ssh and ~\.git* (needs 7-Zip)
        Edge\<profile>\Bookmarks             Microsoft Edge favorites, every profile
        RemoteDesktopManager\...             Remote Desktop Manager data source and settings
        Ssms\...                             SQL Server Management Studio settings
        Desktop\...                          the Desktop folder
        WslHome\wsl-home.tar.gz              the whole home folder of the WSL distribution
        WindowsTerminal\<package>\settings.json
        SqlPrompt\<version>\Snippets|Styles  Red Gate SQL Prompt snippets and styles
        Hosts\hosts                          the Windows hosts file

    The default <BackupRoot> is C:\Work\1729\backups\monthly, so the weekly NAS sync (Sync-Work.ps1)
    carries the result to the NAS. For that reason the two items that contain secrets (Bitwarden,
    SSH/Git) are ALWAYS encrypted: with no password they are skipped, never written in clear.

    How it works:
      - Items are independent: one that is missing or fails does not stop the others. A summary
        table (OK / SKIPPED / FAILED) closes the run.
      - Interactive items (Bitwarden, SshGit) run first, so you can walk away afterwards. Use
        -Skip Bitwarden,SshGit for a fully unattended run.
      - Archives are written to a .partial file and renamed only when complete and verified.
      - Nothing outside <BackupRoot>\<FolderName> is ever written, and nothing is ever deleted
        (running again in the same month overwrites the same files; files that no longer exist on
        the source stay in the backup folder).
      - Files that applications keep open (Edge, RDM, ...) are read with shared access.
      - -WhatIf shows what would be backed up without writing anything or prompting.

    Exit codes:  0 = OK (skipped items are not errors), 1 = at least one item FAILED (see the log),
    2 = could not start (invalid parameters).

    Logs go to %LOCALAPPDATA%\Backup-Monthly\logs (never inside C:\Work).

.PARAMETER BackupRoot
    Folder that contains one sub-folder per month. Created if missing.
    Default C:\Work\1729\backups\monthly.

.PARAMETER FolderName
    Name of the sub-folder of this run. Default: the current month, yyyy-MM.

.PARAMETER Only
    Run only these items.

.PARAMETER Skip
    Do not run these items. Items: Bitwarden, SshGit, Edge, RemoteDesktopManager, Ssms, Desktop,
    WslHome, WindowsTerminal, SqlPrompt, Hosts.

.PARAMETER WslDistro
    WSL distribution whose home folder is archived. Default Debian.

.PARAMETER WslExclude
    tar --exclude patterns for the WSL home archive (e.g. '.cache', 'node_modules'). Default: none,
    the whole home is archived.

.PARAMETER Threads
    robocopy threads (/MT). Default 8.

.PARAMETER LogDirectory
    Where logs are written. Default %LOCALAPPDATA%\Backup-Monthly\logs.

.PARAMETER LogRetentionDays
    Logs older than this are deleted. Default 90.

.EXAMPLE
    .\Backup-Monthly.ps1 -WhatIf
    Dry run: lists what would be backed up, writes nothing.

.EXAMPLE
    .\Backup-Monthly.ps1
    Full monthly backup (asks for a backup password and for the Bitwarden master password).

.EXAMPLE
    .\Backup-Monthly.ps1 -Skip Bitwarden,SshGit,Desktop
    Unattended items only, without the Desktop folder.

.EXAMPLE
    .\Backup-Monthly.ps1 -Only WslHome -WslExclude '.cache','node_modules'
    Only the WSL home archive, without caches.

.NOTES
    Author: Work Laptop Setup Repository
    Version: 1.0
    Requires: PowerShell 5.1 or later and robocopy. Optional: Bitwarden CLI (bw) for Bitwarden,
    7-Zip for SshGit, WSL for WslHome.
    The backup password is passed to bw and 7z.exe as a command-line argument, so it is visible to
    other processes of the same machine while they run. It must not contain double quotes.
#>

#Requires -Version 5.1

[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$BackupRoot = 'C:\Work\1729\backups\monthly',
    [ValidatePattern('^[^\\/:*?"<>|]+$')]
    [string]$FolderName = (Get-Date -Format 'yyyy-MM'),

    [ValidateSet('Bitwarden', 'SshGit', 'Edge', 'RemoteDesktopManager', 'Ssms', 'Desktop', 'WslHome', 'WindowsTerminal', 'SqlPrompt', 'Hosts')]
    [string[]]$Only = @(),
    [ValidateSet('Bitwarden', 'SshGit', 'Edge', 'RemoteDesktopManager', 'Ssms', 'Desktop', 'WslHome', 'WindowsTerminal', 'SqlPrompt', 'Hosts')]
    [string[]]$Skip = @(),

    [string]$WslDistro = 'Debian',
    [string[]]$WslExclude = @(),

    [ValidateRange(1, 128)]
    [int]$Threads = 8,

    [string]$LogDirectory = (Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'Backup-Monthly\logs'),
    [ValidateRange(1, 3650)]
    [int]$LogRetentionDays = 90
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$script:DryRun = [bool]$WhatIfPreference
$script:LogFile = $null
$script:RobocopyLog = $null
$script:Warnings = 0
$script:Errors = 0
$script:Dest = $null
$script:BackupPassword = $null

$LocalAppData = [Environment]::GetFolderPath('LocalApplicationData')
$RoamingAppData = [Environment]::GetFolderPath('ApplicationData')
$UserHome = [Environment]::GetFolderPath('UserProfile')

# Order matters: the items that ask questions come first
$AllItems = @('Bitwarden', 'SshGit', 'Edge', 'RemoteDesktopManager', 'Ssms', 'Desktop', 'WslHome', 'WindowsTerminal', 'SqlPrompt', 'Hosts')

# ----------------------------------------------------------------------------- helpers

function Write-Log {
    param(
        [Parameter(Mandatory)][string]$Message,
        [ValidateSet('INFO', 'WARN', 'ERROR')][string]$Level = 'INFO'
    )

    if ($Level -eq 'WARN') { $script:Warnings++ }
    if ($Level -eq 'ERROR') { $script:Errors++ }

    $line = '{0:yyyy-MM-dd HH:mm:ss} [{1,-5}] {2}' -f (Get-Date), $Level, $Message
    $color = switch ($Level) { 'WARN' { 'Yellow' } 'ERROR' { 'Red' } default { 'Gray' } }
    Write-Host $line -ForegroundColor $color

    if ($script:LogFile) {
        try {
            [System.IO.File]::AppendAllText($script:LogFile, $line + [Environment]::NewLine)
        }
        catch {
            # A broken log must never stop the backup
        }
    }
}

function Initialize-Log {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    try {
        [void][System.IO.Directory]::CreateDirectory($LogDirectory)
        $script:LogFile = Join-Path $LogDirectory "Backup-Monthly_$stamp.log"
        $script:RobocopyLog = Join-Path $LogDirectory "Backup-Monthly_${stamp}_robocopy.log"

        # Retention: only this script's own log files, in its own log folder
        Get-ChildItem -LiteralPath $LogDirectory -Filter 'Backup-Monthly_*.log' -File -ErrorAction SilentlyContinue |
            Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$LogRetentionDays) } |
            Remove-Item -Force -WhatIf:$false -ErrorAction SilentlyContinue
    }
    catch {
        $script:LogFile = $null
        $script:RobocopyLog = Join-Path ([System.IO.Path]::GetTempPath()) "Backup-Monthly_${stamp}_robocopy.log"
        Write-Log "Cannot write logs to '$LogDirectory': $($_.Exception.Message)" 'WARN'
    }
}

function New-Outcome {
    param(
        [Parameter(Mandatory)][ValidateSet('OK', 'SKIPPED', 'FAILED')][string]$Status,
        [Parameter(Mandatory)][string]$Detail
    )
    [pscustomobject]@{ PSTypeName = 'BackupOutcome'; Status = $Status; Detail = $Detail }
}

function ConvertTo-CommandLine {
    # Quotes arguments for CreateProcess (backslashes before a quote are doubled)
    param([string[]]$Arguments)
    ($Arguments | ForEach-Object {
        if ($_ -eq '') { '""' }
        elseif ($_ -match '[\s"]') { '"' + (($_ -replace '(\\*)"', '$1$1\"') -replace '(\\+)$', '$1$1') + '"' }
        else { $_ }
    }) -join ' '
}

function Invoke-Native {
    # Runs a program and returns ExitCode and Output; never throws on a non-zero exit code.
    # Arguments are never logged (some carry the backup password).
    #   -StdoutOnly   the output is stdout only (no stderr noise, e.g. Node warnings from bw)
    #   -Interactive  the program uses this console (prompts); nothing is captured
    param(
        [Parameter(Mandatory)][string]$FilePath,
        [string[]]$Arguments = @(),
        [string]$WorkingDirectory,
        [switch]$StdoutOnly,
        [switch]$Interactive
    )

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $FilePath
    $psi.Arguments = ConvertTo-CommandLine $Arguments
    $psi.UseShellExecute = $false
    # Push-Location only changes the PowerShell location, not the folder the program starts in
    if ($WorkingDirectory) { $psi.WorkingDirectory = $WorkingDirectory }
    if (-not $Interactive) {
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError = $true
        $psi.CreateNoWindow = $true
    }

    $process = [System.Diagnostics.Process]::Start($psi)
    try {
        $output = ''
        if (-not $Interactive) {
            # Both streams are read at the same time: reading one after the other can deadlock
            $stdout = $process.StandardOutput.ReadToEndAsync()
            $stderr = $process.StandardError.ReadToEndAsync()
            $process.WaitForExit()
            $output = $stdout.Result
            if (-not $StdoutOnly) { $output = $output + [Environment]::NewLine + $stderr.Result }
        }
        else {
            $process.WaitForExit()
        }
        [pscustomobject]@{
            ExitCode = $process.ExitCode
            # wsl.exe prints its own messages in UTF-16: drop the NUL characters
            Output   = ($output -replace "`0", '').Trim()
        }
    }
    finally {
        $process.Dispose()
    }
}

function ConvertTo-PlainText {
    param([Parameter(Mandatory)][securestring]$Secure)
    $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secure)
    try { [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) }
    finally { [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
}

function Get-BackupPassword {
    # Asked once per run; protects the Bitwarden export and the SSH/Git zip
    if ($null -eq $script:BackupPassword) {
        $first = ConvertTo-PlainText (Read-Host 'Backup password (protects the Bitwarden export and the SSH/Git zip)' -AsSecureString)
        $second = ConvertTo-PlainText (Read-Host 'Repeat the backup password' -AsSecureString)
        if ([string]::IsNullOrEmpty($first)) { throw 'Empty backup password: nothing is written without encryption.' }
        if ($first -ne $second) { throw 'The two passwords do not match.' }
        if ($first.Contains('"')) { throw 'The backup password must not contain double quotes.' }
        $script:BackupPassword = $first
    }
    $script:BackupPassword
}

function Find-7Zip {
    $command = Get-Command 7z.exe -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($command) { return $command.Source }
    foreach ($folder in @([Environment]::GetFolderPath('ProgramFiles'), [Environment]::GetFolderPath('ProgramFilesX86'))) {
        $candidate = Join-Path $folder '7-Zip\7z.exe'
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate }
    }
    return $null
}

function Test-ProcessRunning {
    param([string]$ProcessName, [string]$Label)
    if (Get-Process -Name $ProcessName -ErrorAction SilentlyContinue) {
        Write-Log "$Label is running: close it for a consistent copy (the backup continues anyway)." 'WARN'
    }
}

function Copy-FileShared {
    # Copies one file, reading it with shared access so that a file kept open by its application
    # (Edge, RDM, ...) can still be copied. Keeps the last write time.
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Destination
    )

    if ($script:DryRun) {
        Write-Log "WhatIf: would copy '$Path' -> '$Destination'"
        return
    }

    [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Destination))
    $share = [System.IO.FileShare]::ReadWrite -bor [System.IO.FileShare]::Delete
    $in = New-Object System.IO.FileStream($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, $share)
    try {
        $out = [System.IO.File]::Create($Destination)
        try { $in.CopyTo($out) }
        finally { $out.Dispose() }
    }
    finally {
        $in.Dispose()
    }
    [System.IO.File]::SetLastWriteTime($Destination, [System.IO.File]::GetLastWriteTime($Path))
    Write-Log "Copied '$Path'"
}

function Copy-Directory {
    # robocopy /E (never /MIR, /PURGE): nothing is deleted in the destination
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Destination,
        [string[]]$ExcludeDirectory = @(),
        [string[]]$ExcludeFile = @()
    )

    $roboArgs = @(
        $Path.TrimEnd('\'), $Destination.TrimEnd('\'),
        '/E', '/COPY:DAT', '/DCOPY:DAT',
        '/XJ',                          # do not follow junctions (loops, other volumes)
        "/MT:$Threads",
        '/R:2', '/W:2',
        '/NP', '/NDL',
        "/UNILOG+:$script:RobocopyLog"  # details go to the log file, the console stays quiet
    )
    if ($script:DryRun) { $roboArgs += '/L' }
    if ($ExcludeDirectory.Count -gt 0) { $roboArgs += '/XD'; $roboArgs += $ExcludeDirectory }
    if ($ExcludeFile.Count -gt 0) { $roboArgs += '/XF'; $roboArgs += $ExcludeFile }

    $exit = (Invoke-Native 'robocopy.exe' $roboArgs).ExitCode

    # robocopy exit code is a bit mask: 1 = copied, 2 = extra on destination, 4 = mismatches,
    # 8 = some files failed, 16 = fatal error. 0-7 are success.
    if ($exit -ge 8) {
        throw "robocopy of '$Path' finished with errors (exit code $exit). Details: $script:RobocopyLog"
    }
    if ($exit -band 4) {
        Write-Log "robocopy of '$Path' reported mismatched files (exit code $exit). Details: $script:RobocopyLog" 'WARN'
    }
    $verb = if ($script:DryRun) { 'WhatIf: would copy' } else { 'Copied' }
    Write-Log "$verb folder '$Path'"
}

# ----------------------------------------------------------------------------- items
# Each Backup-<Item> returns New-Outcome; an exception means FAILED.

function Backup-Bitwarden {
    $bw = Get-Command bw -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $bw) { return New-Outcome 'SKIPPED' 'Bitwarden CLI (bw) not found. Install it with: winget install Bitwarden.CLI' }

    $final = Join-Path $script:Dest 'Bitwarden\bitwarden-export.json'
    if ($script:DryRun) {
        Write-Log "WhatIf: would export the vault with '$($bw.Source)' (encrypted_json) to '$final'"
        return New-Outcome 'OK' 'WhatIf: nothing written'
    }

    $password = Get-BackupPassword
    $partial = $final + '.partial'
    $loggedInHere = $false
    $session = $null
    try {
        $status = $null
        $r = Invoke-Native $bw.Source @('status') -StdoutOnly
        try { $status = ($r.Output | ConvertFrom-Json).status }
        catch { throw "Cannot read the output of 'bw status': $($r.Output)" }

        $env:BW_MASTER_PW = ConvertTo-PlainText (Read-Host 'Bitwarden master password' -AsSecureString)

        if ($status -eq 'unauthenticated') {
            $email = Read-Host 'Bitwarden e-mail'
            Write-Log 'Logging in to Bitwarden (answer the two-step login prompt, if any)...'
            $r = Invoke-Native $bw.Source @('login', $email, '--passwordenv', 'BW_MASTER_PW') -Interactive
            if ($r.ExitCode -ne 0) { throw 'bw login failed.' }
            $loggedInHere = $true
        }

        $r = Invoke-Native $bw.Source @('unlock', '--passwordenv', 'BW_MASTER_PW', '--raw') -StdoutOnly
        if ($r.ExitCode -ne 0 -or -not $r.Output) { throw 'Cannot unlock the vault (wrong master password?).' }
        $session = $r.Output
        Remove-Item Env:BW_MASTER_PW -ErrorAction SilentlyContinue

        $r = Invoke-Native $bw.Source @('sync', '--session', $session)
        if ($r.ExitCode -ne 0) { Write-Log "bw sync failed, exporting the local copy of the vault: $($r.Output)" 'WARN' }

        [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($final))
        if (Test-Path -LiteralPath $partial) { Remove-Item -LiteralPath $partial -Force }
        $r = Invoke-Native $bw.Source @('export', '--format', 'encrypted_json', '--password', $password, '--output', $partial, '--session', $session)
        if ($r.ExitCode -ne 0) { throw "bw export failed: $($r.Output)" }
        if (-not (Test-Path -LiteralPath $partial -PathType Leaf) -or (Get-Item -LiteralPath $partial).Length -eq 0) {
            throw 'bw export produced no file.'
        }

        # Safety net: never keep a clear-text export
        $encrypted = $false
        try { $encrypted = [bool](Get-Content -LiteralPath $partial -Raw | ConvertFrom-Json).encrypted } catch { }
        if (-not $encrypted) {
            Remove-Item -LiteralPath $partial -Force
            throw 'The export is not encrypted: it was deleted.'
        }

        Move-Item -LiteralPath $partial -Destination $final -Force
        Write-Log "Bitwarden export written to '$final'"
        return New-Outcome 'OK' ('{0:N0} KB, encrypted with the backup password' -f ((Get-Item -LiteralPath $final).Length / 1KB))
    }
    finally {
        Remove-Item Env:BW_MASTER_PW -ErrorAction SilentlyContinue
        if (Test-Path -LiteralPath $partial) { Remove-Item -LiteralPath $partial -Force -ErrorAction SilentlyContinue }
        if ($session) { [void](Invoke-Native $bw.Source @('lock')) }
        if ($loggedInHere) { [void](Invoke-Native $bw.Source @('logout')) }   # leave the CLI as we found it
    }
}

function Backup-SshGit {
    $seven = Find-7Zip
    if (-not $seven) { return New-Outcome 'SKIPPED' '7-Zip not found (needed for the encrypted zip).' }

    $names = @(Get-ChildItem -LiteralPath $UserHome -Force |
            Where-Object { $_.Name -eq '.ssh' -or $_.Name -like '.git*' } |
            Select-Object -ExpandProperty Name)
    if ($names.Count -eq 0) { return New-Outcome 'SKIPPED' "No .ssh or .git* items in '$UserHome'." }

    $final = Join-Path $script:Dest 'SshGit\ssh-git.zip'
    if ($script:DryRun) {
        Write-Log "WhatIf: would zip ($($names -join ', ')) from '$UserHome' into '$final' (AES-256)"
        return New-Outcome 'OK' 'WhatIf: nothing written'
    }

    $password = Get-BackupPassword
    $partial = $final + '.partial'
    [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($final))
    if (Test-Path -LiteralPath $partial) { Remove-Item -LiteralPath $partial -Force }

    try {
        # Relative names (working directory = home) keep the archive free of absolute paths.
        # -mem=AES256: strong encryption (the file NAMES stay visible in a zip, the content does not)
        $r = Invoke-Native $seven (@('a', '-tzip', '-mem=AES256', "-p$password", '-bso0', '-bsp0', $partial) + $names) -WorkingDirectory $UserHome
        # Exit code 1 means some files could not be read: for keys that is a failed backup
        if ($r.ExitCode -ne 0) { throw "7-Zip failed (exit code $($r.ExitCode)): $($r.Output)" }

        $r = Invoke-Native $seven @('t', "-p$password", '-bso0', '-bsp0', $partial)
        if ($r.ExitCode -ne 0) { throw "The zip failed its integrity test: $($r.Output)" }

        Move-Item -LiteralPath $partial -Destination $final -Force
    }
    finally {
        if (Test-Path -LiteralPath $partial) { Remove-Item -LiteralPath $partial -Force -ErrorAction SilentlyContinue }
    }

    Write-Log "Zip written to '$final' ($($names -join ', '))"
    New-Outcome 'OK' ('{0}, {1:N0} KB' -f ($names -join ' '), ((Get-Item -LiteralPath $final).Length / 1KB))
}

function Backup-Edge {
    $userData = Join-Path $LocalAppData 'Microsoft\Edge\User Data'
    if (-not (Test-Path -LiteralPath $userData -PathType Container)) { return New-Outcome 'SKIPPED' 'Microsoft Edge profile folder not found.' }

    $profiles = @(Get-ChildItem -LiteralPath $userData -Directory |
            Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'Bookmarks') -PathType Leaf })
    if ($profiles.Count -eq 0) { return New-Outcome 'SKIPPED' 'No Edge profile has a Bookmarks file.' }

    foreach ($profile in $profiles) {
        Copy-FileShared -Path (Join-Path $profile.FullName 'Bookmarks') -Destination (Join-Path $script:Dest "Edge\$($profile.Name)\Bookmarks")
    }
    New-Outcome 'OK' ("$($profiles.Count) profile(s): " + (($profiles | Select-Object -ExpandProperty Name) -join ', '))
}

function Backup-RemoteDesktopManager {
    $source = Join-Path $LocalAppData 'Devolutions\RemoteDesktopManager'
    if (-not (Test-Path -LiteralPath $source -PathType Container)) { return New-Outcome 'SKIPPED' 'Remote Desktop Manager data folder not found.' }

    Test-ProcessRunning -ProcessName 'RemoteDesktopManager' -Label 'Remote Desktop Manager'
    # Connections.db is the data source; the rest are settings, templates and workspaces
    Copy-Directory -Path $source -Destination (Join-Path $script:Dest 'RemoteDesktopManager') `
        -ExcludeDirectory @('WebView2.Cache') -ExcludeFile @('*.log', '*.debug')
    New-Outcome 'OK' 'data source and settings'
}

function Backup-Ssms {
    $roaming = Join-Path $RoamingAppData 'Microsoft\SQL Server Management Studio'
    $local = Join-Path $LocalAppData 'Microsoft\SSMS'
    $copied = New-Object System.Collections.Generic.List[string]

    Test-ProcessRunning -ProcessName 'Ssms' -Label 'SQL Server Management Studio'

    # Roaming: UserSettings.xml (connections, MRU) and RegSrvr*.xml (registered servers)
    if (Test-Path -LiteralPath $roaming -PathType Container) {
        Copy-Directory -Path $roaming -Destination (Join-Path $script:Dest 'Ssms\Roaming')
        $copied.Add('Roaming')
    }

    # Local: per installed version only the settings, never the caches and extensions
    if (Test-Path -LiteralPath $local -PathType Container) {
        foreach ($version in @(Get-ChildItem -LiteralPath $local -Directory | Where-Object { $_.Name -match '^\d+\.\d+_' })) {
            $target = Join-Path $script:Dest "Ssms\Local\$($version.Name)"
            foreach ($folder in @('Settings', 'UnifiedSettings')) {
                $path = Join-Path $version.FullName $folder
                if (Test-Path -LiteralPath $path -PathType Container) {
                    Copy-Directory -Path $path -Destination (Join-Path $target $folder)
                    $copied.Add("$($version.Name)\$folder")
                }
            }
            $json = Join-Path $version.FullName 'settings.json'
            if (Test-Path -LiteralPath $json -PathType Leaf) {
                Copy-FileShared -Path $json -Destination (Join-Path $target 'settings.json')
                $copied.Add("$($version.Name)\settings.json")
            }
        }
    }

    if ($copied.Count -eq 0) { return New-Outcome 'SKIPPED' 'No SSMS settings found.' }
    New-Outcome 'OK' ($copied -join ', ')
}

function Backup-Desktop {
    $desktop = [Environment]::GetFolderPath('Desktop')
    if (-not (Test-Path -LiteralPath $desktop -PathType Container)) { return New-Outcome 'SKIPPED' "Desktop folder '$desktop' not found." }

    Copy-Directory -Path $desktop -Destination (Join-Path $script:Dest 'Desktop') -ExcludeFile @('Thumbs.db', '~$*')
    New-Outcome 'OK' $desktop
}

function Backup-WslHome {
    $wsl = Get-Command wsl.exe -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $wsl) { return New-Outcome 'SKIPPED' 'wsl.exe not found.' }

    # Starts the distribution if it is stopped
    $r = Invoke-Native $wsl.Source @('-d', $WslDistro, '--exec', 'true')
    if ($r.ExitCode -ne 0) { throw "Cannot start the WSL distribution '$WslDistro': $($r.Output)" }

    $final = Join-Path $script:Dest 'WslHome\wsl-home.tar.gz'
    if ($script:DryRun) {
        Write-Log "WhatIf: would archive the home folder of '$WslDistro' into '$final'"
        return New-Outcome 'OK' 'WhatIf: nothing written'
    }

    $partial = $final + '.partial'
    [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($final))
    if (Test-Path -LiteralPath $partial) { Remove-Item -LiteralPath $partial -Force }

    $r = Invoke-Native $wsl.Source @('-d', $WslDistro, '--exec', 'wslpath', '-a', '-u', ($partial -replace '\\', '/'))
    if ($r.ExitCode -ne 0 -or -not $r.Output) { throw "Cannot translate '$partial' to a WSL path: $($r.Output)" }
    $unixPartial = $r.Output

    try {
        Write-Log "Archiving the home folder of '$WslDistro' (this can take several minutes)..."
        # tar writes the archive itself: piping it through PowerShell would corrupt the binary data
        $tarArgs = @('-d', $WslDistro, '--cd', '~', '--exec', 'tar', '-czf', $unixPartial)
        $tarArgs += @($WslExclude | ForEach-Object { "--exclude=$_" })
        $tarArgs += '.'
        $r = Invoke-Native $wsl.Source $tarArgs
        # tar exit codes: 0 OK, 1 some files changed while being read, 2 fatal
        if ($r.ExitCode -ge 2) { throw "tar failed (exit code $($r.ExitCode)): $($r.Output)" }
        if ($r.ExitCode -eq 1) { Write-Log "tar warning (files changed while being archived): $($r.Output)" 'WARN' }

        $r = Invoke-Native $wsl.Source @('-d', $WslDistro, '--exec', 'gzip', '-t', $unixPartial)
        if ($r.ExitCode -ne 0) { throw "The archive failed its integrity test: $($r.Output)" }

        Move-Item -LiteralPath $partial -Destination $final -Force
    }
    finally {
        if (Test-Path -LiteralPath $partial) { Remove-Item -LiteralPath $partial -Force -ErrorAction SilentlyContinue }
    }

    Write-Log "WSL home archive written to '$final'"
    New-Outcome 'OK' ('{0}, {1:N1} MB' -f $WslDistro, ((Get-Item -LiteralPath $final).Length / 1MB))
}

function Backup-WindowsTerminal {
    $sources = New-Object System.Collections.Generic.List[object]

    $packages = Join-Path $LocalAppData 'Packages'
    if (Test-Path -LiteralPath $packages -PathType Container) {
        # Stable and Preview Store packages
        foreach ($package in @(Get-ChildItem -LiteralPath $packages -Directory -Filter 'Microsoft.WindowsTerminal*')) {
            $file = Join-Path $package.FullName 'LocalState\settings.json'
            if (Test-Path -LiteralPath $file -PathType Leaf) { $sources.Add(@{ Name = $package.Name; File = $file }) }
        }
    }
    $unpackaged = Join-Path $LocalAppData 'Microsoft\Windows Terminal\settings.json'
    if (Test-Path -LiteralPath $unpackaged -PathType Leaf) { $sources.Add(@{ Name = 'Unpackaged'; File = $unpackaged }) }

    if ($sources.Count -eq 0) { return New-Outcome 'SKIPPED' 'No Windows Terminal settings.json found.' }
    foreach ($source in $sources) {
        Copy-FileShared -Path $source.File -Destination (Join-Path $script:Dest "WindowsTerminal\$($source.Name)\settings.json")
    }
    New-Outcome 'OK' (($sources | ForEach-Object { $_.Name }) -join ', ')
}

function Backup-SqlPrompt {
    $redGate = Join-Path $LocalAppData 'Red Gate'
    if (-not (Test-Path -LiteralPath $redGate -PathType Container)) { return New-Outcome 'SKIPPED' 'Red Gate folder not found.' }

    $copied = New-Object System.Collections.Generic.List[string]
    # One folder per major version ("SQL Prompt 11"): keep them apart
    foreach ($version in @(Get-ChildItem -LiteralPath $redGate -Directory -Filter 'SQL Prompt*')) {
        foreach ($folder in @('Snippets', 'Styles')) {
            $path = Join-Path $version.FullName $folder
            if (Test-Path -LiteralPath $path -PathType Container) {
                Copy-Directory -Path $path -Destination (Join-Path $script:Dest "SqlPrompt\$($version.Name)\$folder")
                $copied.Add("$($version.Name)\$folder")
            }
        }
    }

    if ($copied.Count -eq 0) { return New-Outcome 'SKIPPED' 'No SQL Prompt Snippets or Styles folder found.' }
    New-Outcome 'OK' ($copied -join ', ')
}

function Backup-Hosts {
    $hosts = Join-Path ([Environment]::GetFolderPath('Windows')) 'System32\drivers\etc\hosts'
    if (-not (Test-Path -LiteralPath $hosts -PathType Leaf)) { return New-Outcome 'SKIPPED' "'$hosts' not found." }

    Copy-FileShared -Path $hosts -Destination (Join-Path $script:Dest 'Hosts\hosts')
    New-Outcome 'OK' $hosts
}

# ----------------------------------------------------------------------------- main

function Invoke-Backup {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    Initialize-Log
    $mode = if ($script:DryRun) { ' (WhatIf: nothing is written)' } else { '' }
    Write-Log "Backup-Monthly started$mode. Log: $script:LogFile"

    # ---- validate parameters -------------------------------------------------------------
    $root = [System.IO.Path]::GetFullPath($BackupRoot).TrimEnd('\')
    if ($root.Length -le 3) {
        Write-Log "BackupRoot '$BackupRoot' is a drive root: refused." 'ERROR'
        return 2
    }
    $script:Dest = Join-Path $root $FolderName

    $selected = @($AllItems | Where-Object { ($Only.Count -eq 0 -or $Only -contains $_) -and ($Skip -notcontains $_) })
    if ($selected.Count -eq 0) {
        Write-Log 'No item selected (check -Only and -Skip).' 'ERROR'
        return 2
    }

    Write-Log "Destination: $script:Dest"
    Write-Log "Items:       $($selected -join ', ')"

    if (-not $script:DryRun) { [void][System.IO.Directory]::CreateDirectory($script:Dest) }

    # ---- run the items -------------------------------------------------------------------
    $results = New-Object System.Collections.Generic.List[object]
    foreach ($name in $selected) {
        Write-Log "--- $name"
        try {
            # Keep only the outcome: stray pipeline output of a helper must not become the result
            $outcome = @(& "Backup-$name") |
                Where-Object { $_ -and $_.PSObject.TypeNames -contains 'BackupOutcome' } |
                Select-Object -Last 1
            if (-not $outcome) { $outcome = New-Outcome 'FAILED' 'The item returned no result.' }
        }
        catch {
            $outcome = New-Outcome 'FAILED' $_.Exception.Message
        }

        switch ($outcome.Status) {
            'FAILED' { Write-Log "${name}: FAILED: $($outcome.Detail)" 'ERROR' }
            'SKIPPED' { Write-Log "${name}: skipped: $($outcome.Detail)" 'WARN' }
            default { Write-Log "${name}: OK ($($outcome.Detail))" }
        }
        $results.Add([pscustomobject]@{ Item = $name; Status = $outcome.Status; Detail = $outcome.Detail })
    }

    # ---- summary -------------------------------------------------------------------------
    Write-Log '--- Summary'
    $table = ($results | Format-Table -AutoSize -Wrap | Out-String).TrimEnd()
    foreach ($line in ($table -split "`r?`n" | Where-Object { $_.Trim() })) { Write-Log $line }
    $failed = @($results | Where-Object { $_.Status -eq 'FAILED' }).Count
    $skippedCount = @($results | Where-Object { $_.Status -eq 'SKIPPED' }).Count
    Write-Log ("Finished in {0:hh\:mm\:ss}. Failed: {1}, skipped: {2}. Destination: {3}" -f $stopwatch.Elapsed, $failed, $skippedCount, $script:Dest)

    if ($failed -gt 0) { return 1 }
    return 0
}

try {
    $exitCode = Invoke-Backup
}
catch {
    Write-Log "Unexpected error: $($_.Exception.Message) at $($_.ScriptStackTrace)" 'ERROR'
    $exitCode = 1
}

exit $exitCode
