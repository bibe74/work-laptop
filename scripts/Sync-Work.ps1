<#
.SYNOPSIS
    Weekly backup of C:\Work to the NAS: files are copied, Git repositories are mirrored.

.DESCRIPTION
    Implements section 7 of docs/configuration/workspace-structure.md.

    Everything is written under ONE folder of the NAS share (default \\NAS-1729\Work\Git), keeping
    exactly the same folder structure as C:\Work:

        C:\Work\Metra\documents\...        ->  \\NAS-1729\Work\Git\Metra\documents\...      (file copy)
        C:\Work\Metra\repos\BI.Fabric      ->  \\NAS-1729\Work\Git\Metra\repos\BI.Fabric.git (bare mirror)

    1. Git repositories
       Every folder that contains a .git (anywhere under the source, not only under "repos") is
       a repository. It is NOT copied as a working tree. Instead `git push --mirror` updates a
       bare repository (<repo>.git) at the same relative path on the NAS. The bare repository is
       created on first use. Uncommitted changes are NOT part of the mirror: the script lists
       the repositories that have some.

    2. Everything else
       robocopy /E (never /MIR, /PURGE): new and changed files are copied; files deleted or
       renamed locally are left on the NAS, so an accidental deletion is never propagated.

    Safety rules:
      - Writes only inside <NasRoot>\<DestinationFolder>. Other folders of the share (_old,
        _Archive, @Recycle, @Recently-Snapshot, ...) are never touched, and DestinationFolder
        is refused if it is one of them.
      - The destination folder must already exist (a typo in the parameters never creates a
        new folder on the NAS).
      - Never deletes anything on the NAS, except Git refs of branches/tags that no longer
        exist locally (this is what a mirror is).
      - Raw Docker volumes (docker_volumes) and node_modules are excluded: copying live
        database files produces corrupt backups. Export a .bak / tarball into a backups folder
        instead (see section 6.3 of the workspace-structure doc).
      - Only one instance can run at a time.
      - -WhatIf lists what would be copied/mirrored without writing anything on the NAS.

    Exit codes:  0 = OK, 1 = completed with errors (see the log), 2 = could not start
    (NAS unreachable, invalid parameters), 3 = another instance is already running.

    Logs go to %LOCALAPPDATA%\Sync-Work\logs (never inside C:\Work).

.PARAMETER Source
    Folder to back up. Default C:\Work.

.PARAMETER NasRoot
    Root of the NAS share. Default \\NAS-1729\Work.

.PARAMETER DestinationFolder
    Folder of the share that receives the backup. Must already exist. Default Git.

.PARAMETER ExcludePath
    Paths, relative to Source, that are neither copied nor mirrored. Default: docker_volumes.

.PARAMETER ExcludeDirectory
    Folder names that are skipped at any depth. Default: node_modules, $RECYCLE.BIN,
    System Volume Information.

.PARAMETER ExcludeFile
    File name patterns that are skipped. Default: Thumbs.db, ~$* (Office lock files).

.PARAMETER SkipRepositories
    Only copy files (do not mirror the Git repositories).

.PARAMETER SkipFiles
    Only mirror the Git repositories (do not copy files).

.PARAMETER SkipStatusCheck
    Do not report repositories with uncommitted changes.

.PARAMETER Threads
    robocopy threads (/MT). Default 8.

.PARAMETER NasRetryCount
    Attempts to reach the NAS before giving up (the laptop may wake up before the network).
    Default 3.

.PARAMETER NasRetryDelaySeconds
    Seconds between attempts. Default 60.

.PARAMETER LogDirectory
    Where logs are written. Default %LOCALAPPDATA%\Sync-Work\logs.

.PARAMETER LogRetentionDays
    Logs older than this are deleted. Default 90.

.PARAMETER RegisterTask
    Registers (or updates) the weekly Scheduled Task for the current user and exits. Combine with
    -WhatIf to preview. Source, NasRoot and DestinationFolder are copied into the task; to
    change the other defaults edit the param() block of this script.

.PARAMETER TaskName
    Name of the Scheduled Task. Default Sync-Work-To-NAS.

.PARAMETER TaskDay
    Day of the week of the Scheduled Task. Default Sunday.

.PARAMETER TaskTime
    Time of day (HH:mm) of the Scheduled Task. Default 12:00. If the laptop is off at that
    time, the task runs as soon as possible afterwards.

.EXAMPLE
    .\Sync-Work.ps1 -WhatIf
    Dry run: shows what would be copied and mirrored, writes nothing on the NAS.

.EXAMPLE
    .\Sync-Work.ps1
    Runs the backup now.

.EXAMPLE
    .\Sync-Work.ps1 -RegisterTask -TaskDay Sunday -TaskTime 03:00
    Schedules the weekly run.

.NOTES
    Author: Work Laptop Setup Repository
    Version: 1.0
    Requires: PowerShell 5.1 or later, git and robocopy in PATH.
    The account that runs the task must be able to open the share without a prompt, e.g.
    after:  cmdkey /add:NAS-1729 /user:<nas-user> /pass:<password>
#>

#Requires -Version 5.1

[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$Source = 'C:\Work',
    [string]$NasRoot = '\\NAS-1729\Work',
    [string]$DestinationFolder = 'Git',

    [string[]]$ExcludePath = @('docker_volumes'),
    [string[]]$ExcludeDirectory = @('node_modules', '$RECYCLE.BIN', 'System Volume Information'),
    [string[]]$ExcludeFile = @('Thumbs.db', '~$*'),

    [switch]$SkipRepositories,
    [switch]$SkipFiles,
    [switch]$SkipStatusCheck,

    [ValidateRange(1, 128)]
    [int]$Threads = 8,
    [ValidateRange(1, 20)]
    [int]$NasRetryCount = 3,
    [ValidateRange(0, 3600)]
    [int]$NasRetryDelaySeconds = 60,

    [string]$LogDirectory = (Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) 'Sync-Work\logs'),
    [ValidateRange(1, 3650)]
    [int]$LogRetentionDays = 90,

    [switch]$RegisterTask,
    [string]$TaskName = 'Sync-Work-To-NAS',
    [ValidateSet('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')]
    [string]$TaskDay = 'Sunday',
    [ValidatePattern('^([01]\d|2[0-3]):[0-5]\d$')]
    [string]$TaskTime = '12:00'
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version 2.0

$script:DryRun = [bool]$WhatIfPreference
$script:LogFile = $null
$script:Warnings = 0
$script:Errors = 0
$script:NasGitConfig = $null

# Folders of the share that must never be written to (QNAP/Synology system folders included)
$ProtectedFolders = @('_old', '_Archive', '@Recycle', '@Recently-Snapshot')

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
        $script:LogFile = Join-Path $LogDirectory "Sync-Work_$stamp.log"
        $script:RobocopyLog = Join-Path $LogDirectory "Sync-Work_${stamp}_robocopy.log"

        # Retention: only this script's own log files, in its own log folder
        Get-ChildItem -LiteralPath $LogDirectory -Filter 'Sync-Work_*.log' -File -ErrorAction SilentlyContinue |
            Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$LogRetentionDays) } |
            Remove-Item -Force -WhatIf:$false -ErrorAction SilentlyContinue
    }
    catch {
        $script:LogFile = $null
        $script:RobocopyLog = Join-Path ([System.IO.Path]::GetTempPath()) "Sync-Work_${stamp}_robocopy.log"
        Write-Log "Cannot write logs to '$LogDirectory': $($_.Exception.Message)" 'WARN'
    }
}

function Get-NasGitConfig {
    # A private git config file that marks every repository as safe. It is used ONLY for the
    # commands that write to the NAS (see Invoke-Git -ForNas), never for the local repositories.
    #
    # Why a file and not `git -c safe.directory=*`: the NAS share is owned by another account, so
    # git refuses it with "detected dubious ownership". `git push` to a local path starts a
    # separate git-receive-pack process for the destination, and git deliberately drops -c and
    # GIT_CONFIG_COUNT/GIT_CONFIG_PARAMETERS for that process. GIT_CONFIG_GLOBAL is passed on.
    if (-not $script:NasGitConfig) {
        $script:NasGitConfig = Join-Path ([System.IO.Path]::GetTempPath()) ("Sync-Work_gitconfig_{0}.tmp" -f $PID)
        [System.IO.File]::WriteAllText($script:NasGitConfig, "[safe]`n`tdirectory = *`n")
    }
    $script:NasGitConfig
}

function Invoke-Git {
    # Returns ExitCode and Output; never throws on a non-zero exit code.
    param(
        [Parameter(Mandatory)][string[]]$Arguments,
        [switch]$ForNas   # the command writes to (or reads) a repository that lives on the NAS
    )

    $previous = $ErrorActionPreference
    $previousGlobal = $env:GIT_CONFIG_GLOBAL
    $ErrorActionPreference = 'Continue'   # Windows PowerShell turns native stderr into errors otherwise
    try {
        if ($ForNas) { $env:GIT_CONFIG_GLOBAL = Get-NasGitConfig }
        $output = & git @Arguments 2>&1 | ForEach-Object { "$_" }
        [pscustomobject]@{
            ExitCode = $LASTEXITCODE
            Output   = ($output -join [Environment]::NewLine).Trim()
        }
    }
    finally {
        $ErrorActionPreference = $previous
        if ($ForNas) {
            if ($null -eq $previousGlobal) { Remove-Item Env:GIT_CONFIG_GLOBAL -ErrorAction SilentlyContinue }
            else { $env:GIT_CONFIG_GLOBAL = $previousGlobal }
        }
    }
}

function Test-NasReachable {
    param([string]$Path)

    for ($attempt = 1; $attempt -le $NasRetryCount; $attempt++) {
        if (Test-Path -LiteralPath $Path -PathType Container) { return $true }
        if ($attempt -lt $NasRetryCount) {
            Write-Log "NAS path '$Path' not reachable (attempt $attempt of $NasRetryCount), retrying in $NasRetryDelaySeconds s" 'WARN'
            Start-Sleep -Seconds $NasRetryDelaySeconds
        }
    }
    return $false
}

function Find-GitRepository {
    # Walks the tree and returns the full path of every folder that contains a .git (folder or
    # file, so worktrees and submodules count). Repositories are not entered; junctions and
    # symbolic links are not followed; excluded folders are skipped.
    param(
        [Parameter(Mandatory)][string]$Root,
        [string[]]$ExcludedFullPaths = @(),
        [string[]]$ExcludedNames = @()
    )

    $found = New-Object System.Collections.Generic.List[string]
    $pending = New-Object System.Collections.Generic.Stack[string]
    $pending.Push($Root)

    while ($pending.Count -gt 0) {
        $current = $pending.Pop()
        try {
            $children = [System.IO.Directory]::GetDirectories($current)
        }
        catch {
            Write-Log "Cannot read folder '$current': $($_.Exception.Message)" 'WARN'
            continue
        }

        foreach ($child in $children) {
            $name = [System.IO.Path]::GetFileName($child)
            if ($ExcludedNames -contains $name) { continue }
            if ($ExcludedFullPaths -contains $child) { continue }
            if ([System.IO.File]::GetAttributes($child) -band [System.IO.FileAttributes]::ReparsePoint) { continue }

            $dotGit = Join-Path $child '.git'
            if ([System.IO.Directory]::Exists($dotGit) -or [System.IO.File]::Exists($dotGit)) {
                $found.Add($child)
            }
            else {
                $pending.Push($child)
            }
        }
    }

    $found | Sort-Object
}

function Get-RelativePath {
    param([string]$Base, [string]$Full)
    $Full.Substring($Base.Length).TrimStart('\')
}

function Sync-GitMirror {
    # Returns 'Mirrored', 'Skipped' or 'Failed'
    param(
        [Parameter(Mandatory)][string]$Repository,
        [Parameter(Mandatory)][string]$BareRepository,
        [Parameter(Mandatory)][string]$Label
    )

    # 'safe.directory=*' on the command line covers the LOCAL repositories (they may belong to
    # another account). Commands that touch the NAS use Invoke-Git -ForNas instead: -c is not
    # passed on to the git-receive-pack process of a push (see Get-NasGitConfig).
    $safe = @('-c', 'safe.directory=*')

    $check = Invoke-Git ($safe + @('-C', $Repository, 'rev-parse', '--git-dir'))
    if ($check.ExitCode -ne 0) {
        Write-Log "${Label}: not a usable Git repository: $($check.Output)" 'ERROR'
        return 'Failed'
    }

    # An empty repository would turn --mirror into "delete every ref of the existing mirror"
    $refs = Invoke-Git ($safe + @('-C', $Repository, 'for-each-ref', '--count=1', '--format=%(refname)'))
    if ($refs.ExitCode -ne 0) {
        Write-Log "${Label}: cannot list refs: $($refs.Output)" 'ERROR'
        return 'Failed'
    }
    if (-not $refs.Output) {
        Write-Log "${Label}: no commits or refs yet, skipped" 'WARN'
        return 'Skipped'
    }

    $exists = Test-Path -LiteralPath $BareRepository
    if ($exists -and -not (Test-Path -LiteralPath (Join-Path $BareRepository 'HEAD') -PathType Leaf)) {
        Write-Log "${Label}: '$BareRepository' exists but is not a bare Git repository, skipped" 'ERROR'
        return 'Failed'
    }

    if ($script:DryRun) {
        $verb = if ($exists) { 'update' } else { 'create and fill' }
        Write-Log "${Label}: WhatIf, would $verb '$BareRepository'"
        return 'Mirrored'
    }

    if (-not $exists) {
        $init = Invoke-Git ($safe + @('init', '--bare', '--quiet', $BareRepository))
        if ($init.ExitCode -ne 0) {
            Write-Log "${Label}: cannot create '$BareRepository': $($init.Output)" 'ERROR'
            return 'Failed'
        }
    }

    # --no-verify: do not run the repository's own pre-push hooks (tests, LFS, husky, ...)
    $push = Invoke-Git -ForNas ($safe + @('-C', $Repository, 'push', '--mirror', '--no-verify', '--quiet', $BareRepository))
    if ($push.ExitCode -ne 0) {
        Write-Log "${Label}: push --mirror failed: $($push.Output)" 'ERROR'
        return 'Failed'
    }

    # A mirror push does not move HEAD: make the bare repo open on the same branch as the original
    $head = Invoke-Git ($safe + @('-C', $Repository, 'symbolic-ref', '-q', 'HEAD'))
    if ($head.ExitCode -eq 0 -and $head.Output) {
        $set = Invoke-Git -ForNas ($safe + @("--git-dir=$BareRepository", 'symbolic-ref', 'HEAD', $head.Output))
        if ($set.ExitCode -ne 0) {
            Write-Log "${Label}: mirrored, but cannot set HEAD of the bare repository: $($set.Output)" 'WARN'
        }
    }

    Write-Log "${Label}: mirrored"
    return 'Mirrored'
}

function Register-SyncTask {
    $scriptPath = $PSCommandPath
    # Windows PowerShell 5.1 is always installed and is not a Microsoft Store package (those
    # are unreliable when started by the Task Scheduler); the script runs on both editions.
    $shellPath = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
    $shell = Get-Command $shellPath -ErrorAction Stop

    $arguments = '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "{0}" -Source "{1}" -NasRoot "{2}" -DestinationFolder "{3}"' -f `
        $scriptPath, $Source.TrimEnd('\'), $NasRoot.TrimEnd('\'), $DestinationFolder

    $action = New-ScheduledTaskAction -Execute $shell.Source -Argument $arguments
    $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $TaskDay -At $TaskTime
    $settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -RunOnlyIfNetworkAvailable `
        -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries `
        -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Hours 12)
    # Interactive: runs only while the user is logged on, so the NAS credentials stored in
    # Windows Credential Manager are available. No password is stored in the task.
    $user = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $principal = New-ScheduledTaskPrincipal -UserId $user -LogonType Interactive -RunLevel Limited

    $description = "Weekly copy of $Source to $NasRoot\$DestinationFolder (files) and bare Git mirrors. Script: $scriptPath"
    if ($PSCmdlet.ShouldProcess("Scheduled Task '$TaskName'", "Register: every $TaskDay at $TaskTime as $user, running $($shell.Source) $arguments")) {
        Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings `
            -Principal $principal -Description $description -Force | Out-Null
        Write-Host "Scheduled Task '$TaskName' registered: every $TaskDay at $TaskTime as $user."
        Write-Host "Test it now with:  Start-ScheduledTask -TaskName '$TaskName'"
    }
}

# ----------------------------------------------------------------------------- main

function Invoke-Sync {
    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    Initialize-Log
    $mode = if ($script:DryRun) { ' (WhatIf: nothing is written to the NAS)' } else { '' }
    Write-Log "Sync-Work started$mode. Log: $script:LogFile"

    # ---- validate parameters -------------------------------------------------------------
    $src = [System.IO.Path]::GetFullPath($Source).TrimEnd('\')
    if ($src.Length -le 3) {
        Write-Log "Source '$Source' is a drive root: refused." 'ERROR'
        return 2
    }
    if (-not (Test-Path -LiteralPath $src -PathType Container)) {
        Write-Log "Source '$src' does not exist." 'ERROR'
        return 2
    }
    if (-not (Get-ChildItem -LiteralPath $src -Force | Select-Object -First 1)) {
        Write-Log "Source '$src' is empty: nothing to do (refusing to run on an empty source)." 'ERROR'
        return 2
    }

    if ($DestinationFolder -match '[\\/:*?"<>|]' -or [string]::IsNullOrWhiteSpace($DestinationFolder) -or $DestinationFolder -in @('.', '..')) {
        Write-Log "DestinationFolder '$DestinationFolder' must be a single folder name." 'ERROR'
        return 2
    }
    if ($ProtectedFolders -contains $DestinationFolder -or $DestinationFolder.StartsWith('_') -or $DestinationFolder.StartsWith('@')) {
        Write-Log "DestinationFolder '$DestinationFolder' is a protected folder of the share: refused." 'ERROR'
        return 2
    }

    $nas = $NasRoot.TrimEnd('\')
    $dstRoot = Join-Path $nas $DestinationFolder

    # ---- NAS reachable? ------------------------------------------------------------------
    if (-not (Test-NasReachable -Path $nas)) {
        Write-Log "NAS share '$nas' is not reachable. Check the network/VPN and the credentials (cmdkey)." 'ERROR'
        return 2
    }
    if (-not (Test-Path -LiteralPath $dstRoot -PathType Container)) {
        Write-Log "Destination folder '$dstRoot' does not exist. Create it on the NAS first (it is not created automatically)." 'ERROR'
        return 2
    }

    $excludedFull = @($ExcludePath | ForEach-Object { [System.IO.Path]::GetFullPath((Join-Path $src $_)).TrimEnd('\') })

    Write-Log "Source:      $src"
    Write-Log "Destination: $dstRoot"
    Write-Log "Excluded:    $(($excludedFull + $ExcludeDirectory) -join ', ')"

    # ---- find repositories ---------------------------------------------------------------
    Write-Log 'Looking for Git repositories...'
    $repos = @(Find-GitRepository -Root $src -ExcludedFullPaths $excludedFull -ExcludedNames $ExcludeDirectory)
    Write-Log "Found $($repos.Count) Git repositories."

    $mirrored = 0; $skipped = 0; $failed = 0
    $dirty = New-Object System.Collections.Generic.List[string]

    # ---- 1. Git repositories -------------------------------------------------------------
    if (-not $SkipRepositories) {
        Write-Log '--- Mirroring Git repositories'
        foreach ($repo in $repos) {
            $relative = Get-RelativePath -Base $src -Full $repo

            if (-not $SkipStatusCheck) {
                $status = Invoke-Git @('-c', 'safe.directory=*', '-C', $repo, 'status', '--porcelain')
                if ($status.ExitCode -eq 0 -and $status.Output) {
                    $count = @($status.Output -split "`r?`n").Count
                    $dirty.Add("$relative ($count files)")
                    Write-Log "${relative}: $count uncommitted/untracked files are NOT included in the mirror" 'WARN'
                }
            }

            $bare = Join-Path $dstRoot ($relative + '.git')
            switch (Sync-GitMirror -Repository $repo -BareRepository $bare -Label $relative) {
                'Mirrored' { $mirrored++ }
                'Skipped' { $skipped++ }
                default { $failed++ }
            }
        }
        Write-Log "Repositories: $mirrored mirrored, $skipped skipped, $failed failed."
    }

    # ---- 2. Everything else --------------------------------------------------------------
    $robocopyExit = $null
    if (-not $SkipFiles) {
        Write-Log '--- Copying files (new and changed files only, nothing is deleted on the NAS)'

        $excludedDirectories = @($repos) + $excludedFull
        $roboArgs = @(
            $src, $dstRoot,
            '/E',                       # sub-folders, including empty ones. NEVER /MIR or /PURGE
            '/COPY:DAT', '/DCOPY:DAT',  # data, attributes, timestamps (no ACLs/owner: they do not exist on the NAS)
            '/FFT',                     # 2 s timestamp tolerance (NAS file systems)
            '/XJ',                      # do not follow junctions (loops, other volumes)
            "/MT:$Threads",
            '/R:2', '/W:5',
            '/NP', '/NDL', '/TEE',
            "/UNILOG+:$script:RobocopyLog"
        )
        if ($script:DryRun) { $roboArgs += '/L' }
        $roboArgs += '/XD'
        $roboArgs += $excludedDirectories
        $roboArgs += $ExcludeDirectory
        if ($ExcludeFile.Count -gt 0) {
            $roboArgs += '/XF'
            $roboArgs += $ExcludeFile
        }

        & robocopy.exe @roboArgs | Out-Host
        $robocopyExit = $LASTEXITCODE

        # robocopy exit code is a bit mask: 1 = copied, 2 = extra on destination, 4 = mismatches,
        # 8 = some files failed, 16 = fatal error. 0-7 are success.
        if ($robocopyExit -ge 8) {
            Write-Log "robocopy finished with errors (exit code $robocopyExit). Details: $script:RobocopyLog" 'ERROR'
        }
        elseif ($robocopyExit -band 4) {
            Write-Log "robocopy reported mismatched files (exit code $robocopyExit). Details: $script:RobocopyLog" 'WARN'
        }
        else {
            Write-Log "robocopy OK (exit code $robocopyExit). Details: $script:RobocopyLog"
        }
    }

    # ---- summary -------------------------------------------------------------------------
    Write-Log '--- Summary'
    if (-not $SkipRepositories) {
        Write-Log "Repositories mirrored: $mirrored, skipped: $skipped, failed: $failed"
        if ($dirty.Count -gt 0) {
            Write-Log "Repositories with uncommitted work ($($dirty.Count)): $($dirty -join '; ')" 'WARN'
        }
    }
    if ($null -ne $robocopyExit) { Write-Log "robocopy exit code: $robocopyExit" }
    Write-Log ("Finished in {0:hh\:mm\:ss}. Warnings: {1}, errors: {2}." -f $stopwatch.Elapsed, $script:Warnings, $script:Errors)

    if ($script:Errors -gt 0) { return 1 }
    return 0
}

if ($RegisterTask) {
    Register-SyncTask
    exit 0
}

$env:GIT_TERMINAL_PROMPT = '0'   # never wait for credentials in an unattended run

$mutex = New-Object System.Threading.Mutex($false, 'Global\Sync-Work-To-NAS')
$hasLock = $false
try {
    try { $hasLock = $mutex.WaitOne(0) }
    catch [System.Threading.AbandonedMutexException] { $hasLock = $true }   # a previous run was killed

    if (-not $hasLock) {
        Write-Host 'Another Sync-Work instance is already running: exiting.' -ForegroundColor Yellow
        $exitCode = 3
    }
    else {
        try {
            $exitCode = Invoke-Sync
        }
        catch {
            Write-Log "Unexpected error: $($_.Exception.Message) at $($_.ScriptStackTrace)" 'ERROR'
            $exitCode = 1
        }
    }
}
finally {
    if ($hasLock) { $mutex.ReleaseMutex() }
    $mutex.Dispose()
    if ($script:NasGitConfig) { Remove-Item -LiteralPath $script:NasGitConfig -Force -WhatIf:$false -ErrorAction SilentlyContinue }
}

exit $exitCode
