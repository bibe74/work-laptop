# Workspace Structure: Repositories, Containers, Documents, Backups and Invoices

A proposal for a single, predictable directory layout for everything that is produced or received while working for direct customers and for the software house.

The layout is designed so that **one path tells you everything**: who pays you, which Git identity applies, where the backups go, and what the weekly NAS sync has to do.

---

## 1. Goals and constraints

| # | Goal |
|---|------|
| 1 | Keep customers strictly separated (confidentiality, NDA, GDPR). |
| 2 | Use the correct Git identity automatically, without thinking about it. |
| 3 | Keep **code** (Git), **customer data** (never in Git) and **backups** (large, disposable locally) apart, because each has a different sync policy. |
| 4 | Make the weekly sync with the home NAS a loop over a fixed pattern, not a list of special cases. |
| 5 | Keep invoices (Google Drive) organised by the entity that is actually invoiced. |
| 6 | Stay Windows-friendly: short paths, no spaces, no accents. |

### The four design rules

1. **Top-level folder = billing entity.** You invoice Cesi Multimedia, Metra and CodicePlastico. You do **not** invoice A2A, Berg, NSA or Fraternità Sistemi, even though you work for them. They are therefore sub-folders of `CodicePlastico`.
2. **Every workspace has the same four folders**: `repos`, `docker`, `documents`, `backups`. A *workspace* is the folder of a direct customer, or of an end customer of the software house.
3. **Git identity follows the path** (Git `includeIf`), never the individual repository.
4. **Never sync a raw Docker volume or a live database file.** Sync *exports* (`.bak`, `.bacpac`, volume tarballs) instead.

---

## 2. Proposed tree

> Assumption: `1729` in your current path (`C:\Work.Git\1729\...`) is your own umbrella/brand, so it becomes the "own" workspace (this repository, templates, scripts). Adjust if it means something else.

Root: `C:\Work` (short, no spaces; avoids the Windows `MAX_PATH` problems that .NET/SSIS projects hit quickly. Also enable *LongPathsEnabled*).

```text
C:\Work\
├── 1729\                              ← own workspace (main Git identity)
│   ├── repos\
│   │   ├── work-laptop\               ← this repository
│   │   └── work-ops\                  ← personal scripts (the NAS sync is `Sync-Work.ps1` in work-laptop, see §7)
│   ├── docker\
│   ├── documents\
│   └── backups\
│
├── CesiMultimedia\                    ← direct customer (main Git identity)
│   ├── README.md                      ← customer card (see §3.2)
│   ├── repos\
│   ├── docker\
│   ├── documents\
│   └── backups\
│
├── Metra\                             ← direct customer (a.turelli@metra.it)
│   ├── README.md
│   ├── repos\ docker\ documents\ backups\
│
├── CodicePlastico\                    ← software house (alberto.turelli@codiceplastico.com)
│   ├── _shared\                       ← CodicePlastico internal: onboarding, timesheet templates, common tools
│   │   ├── repos\ documents\
│   ├── A2A\
│   │   ├── README.md
│   │   └── repos\ docker\ documents\ backups\
│   ├── Berg\
│   │   └── repos\ docker\ documents\ backups\
│   ├── NSA\
│   │   └── repos\ docker\ documents\ backups\
│   └── FraternitaSistemi\             ← no accent in folder names
│       └── repos\ docker\ documents\ backups\
│
└── _Archive\                          ← finished engagements, moved as a whole (see §9)
    └── 2026\
        └── <Workspace>\
```

Google Drive is **not** under `C:\Work` (see §8): it is mounted by Google Drive for desktop and has its own structure.

### 2.1 Naming conventions

| Item | Convention | Example |
|------|-----------|---------|
| Customer / workspace folders | `PascalCase`, no spaces, no accents | `CesiMultimedia`, `FraternitaSistemi` |
| Repository folders | `lowercase-kebab-case`, **same name as the remote repo** | `a2a-dwh`, `metra-etl` |
| Dates in file names | ISO, sortable: `yyyy-MM-dd` (or `yyyyMMdd-HHmm` for timestamps) | `2026-08-01` |
| Docker stacks | `<workspace>-<project>` | `a2a-dwh`, `metra-reporting` |
| Files from the customer | keep the original name, prefix with the receipt date | `2026-08-01_orders_export.csv` |

---

## 3. What goes into each folder

### 3.1 The four standard folders

```text
<workspace>\
├── repos\                  ← Git working copies. One sub-folder per repo.
│   ├── a2a-dwh\            (SQL projects, SSIS, SSRS, Power BI sources, scripts)
│   └── a2a-etl\
│
├── docker\                 ← one sub-folder per stack
│   └── a2a-dwh\
│       ├── compose.yaml
│       ├── .env.sample     ← committed
│       ├── .env            ← NOT committed (secrets live in Bitwarden)
│       └── init\           ← init SQL scripts, restore scripts
│
├── documents\              ← NEVER in a remote Git repository
│   ├── inbox\              ← received as-is, treated as immutable
│   │   └── 2026-08-01_orders_export.csv
│   ├── ingestion\          ← the exact files used to feed a load (traceability)
│   ├── exports\            ← what the processes produced
│   │   └── 2026-08-01\
│   ├── deliverables\       ← what you handed over to the customer
│   └── specs\              ← requirements, meeting notes, data dictionaries
│
└── backups\
    ├── sqlserver\          ← .bak, mounted into the container as /var/opt/mssql/backup
    ├── bacpac\             ← .bacpac
    └── docker-volumes\     ← tarballs produced by the export script (see §6.3)
```

Rationale:

- **`repos`** only contains things that are meant to be versioned and pushed. Because the folder name equals the remote name, cloning is mechanical.
- **`docker`** keeps the stack definition separate from the application repo, so that you can start a customer's whole environment from one place. Each stack folder is itself a small Git repo (or lives in a `<workspace>-infra` repo). Only `compose.yaml`, `.env.sample` and init scripts are versioned.
- **`documents`** is where "check what changed" happens: `inbox` is never edited, `ingestion`/`exports` are dated, so any two dates can be compared (see §5).
- **`backups`** is a *staging area*: large files, produced locally, copied to the NAS, then pruned locally (see §6.4).

### 3.2 The customer card (`README.md` in each workspace)

A short, non-secret file that answers "how do I work for this customer?". Passwords stay in Bitwarden.

```markdown
# Metra

- Billing entity: Metra (direct)
- Git identity: a.turelli@metra.it  (automatic, see ~/.gitconfig.d/metra.inc)
- Git host: <GitHub / Azure DevOps / GitLab>, organisation <...>
- VPN: <profile name>
- SQL Server containers: host port 14332
- Drive invoices folder: Invoices\<year>\Issued\Metra
- NAS sync: weekly (included)
- Contacts: <name, role, e-mail>
- Notes: <anything non-obvious, e.g. data retention limits, NDA constraints>
```

---

## 4. Git: identity follows the directory

### 4.1 Git configuration: one shared file plus a tiny per-OS stub

The same rules must work from PowerShell and from Debian on WSL (see §4.6), so everything common lives in one file, `%USERPROFILE%\.gitconfig.d\shared.inc`, and each OS keeps only a minimal `.gitconfig` that includes it.

`%USERPROFILE%\.gitconfig.d\shared.inc`:

```ini
[user]
    name = Alberto Federico Turelli
    email = alberto.turelli@gmail.com     ; default: main account (1729, CesiMultimedia)

[core]
    excludesFile = ~/.gitignore_global

; Same folders seen from Windows and from WSL. The pattern that does not
; exist on the current OS simply never matches.
[includeIf "gitdir/i:C:/Work/Metra/"]
    path = ~/.gitconfig.d/metra.inc
[includeIf "gitdir/i:/mnt/c/Work/Metra/"]
    path = ~/.gitconfig.d/metra.inc

[includeIf "gitdir/i:C:/Work/CodicePlastico/"]
    path = ~/.gitconfig.d/codiceplastico.inc
[includeIf "gitdir/i:/mnt/c/Work/CodicePlastico/"]
    path = ~/.gitconfig.d/codiceplastico.inc
```

`%USERPROFILE%\.gitconfig.d\metra.inc`:

```ini
[user]
    email = a.turelli@metra.it
```

`%USERPROFILE%\.gitconfig.d\codiceplastico.inc`:

```ini
[user]
    email = alberto.turelli@codiceplastico.com
```

`%USERPROFILE%\.gitconfig` (Windows stub):

```ini
[include]
    path = ~/.gitconfig.d/shared.inc

[core]
    sshCommand = C:/Windows/System32/OpenSSH/ssh.exe   ; use the Windows OpenSSH client and its ssh-agent
```

Notes:

- `gitdir/i:` is case-insensitive (right for Windows) and the trailing `/` makes the rule apply to every repository below that folder, so the whole `CodicePlastico\<client>\repos\...` subtree is covered by a single rule.
- Use forward slashes in the patterns.
- The main account needs no include file: it is the default.
- `includeIf "gitdir:..."` is evaluated once the repository exists, so it does **not** apply while `git clone` itself is running. That is why the SSH key is chosen through the host alias in the clone URL (§4.2) and not through the include file.

### 4.2 Authenticating with the right account (SSH)

Identity (name/e-mail on commits) and authentication (which key pushes) are different things, and both must match. With several accounts on the same Git host, the SSH agent would offer its keys in turn and the host would accept the first one it knows, which may belong to the wrong account. The fix is one **host alias per account** in `%USERPROFILE%\.ssh\config`, each pinned to its own key with `IdentitiesOnly yes`:

```sshconfig
# Main account (1729, CesiMultimedia): plain host name
Host github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_main
    IdentitiesOnly yes

# Metra
Host github.com-metra
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_metra
    IdentitiesOnly yes

# CodicePlastico and its customers
Host github.com-codiceplastico
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_codiceplastico
    IdentitiesOnly yes
```

(`github.com` is just an example: use the real host of each account, e.g. `ssh.dev.azure.com` or a self-hosted GitLab.)

Clone with the alias, so the right key is used from the very first fetch, and the remote URL keeps it afterwards:

```powershell
cd C:\Work\Metra\repos
git clone git@github.com-metra:<org>/<repo>.git
```

Rules of thumb: one key per account, protected by a passphrase, loaded into the ssh-agent; folder = commit identity (§4.1); remote URL alias = key.

### 4.3 Safety net: fail instead of committing with the wrong e-mail

Optional but cheap. Remove `email` from the global `[user]` section, keep `name`, and add `useConfigOnly`:

```ini
[user]
    name = Alberto Federico Turelli
    useConfigOnly = true
```

Then give the main identity its own include rules for `C:/Work/1729/` and `C:/Work/CesiMultimedia/`. A repository cloned **outside** the known tree will refuse to commit until you set an identity explicitly, instead of silently using the wrong one. The trade-off is two more `includeIf` entries.

### 4.4 Audit: which e-mail does each repo actually use?

```powershell
Get-ChildItem C:\Work -Directory -Recurse -Force -Filter .git -Depth 5 |
  ForEach-Object {
    $repo = $_.Parent.FullName
    [pscustomobject]@{
      Repo  = $repo.Substring(8)
      Email = git -C $repo config user.email
    }
  } | Sort-Object Repo | Format-Table -AutoSize
```

Any `CodicePlastico\...` row that does not show `@codiceplastico.com`, or any `Metra\...` row that does not show `@metra.it`, is a mistake to fix before the next push.

### 4.5 Global ignore file (protects every repo, including ones you forget to configure)

`%USERPROFILE%\.gitignore_global`:

```gitignore
# Secrets
.env
*.pem
*.key
*.pfx
*.ovpn
*.credentials

# Database backups and customer data
*.bak
*.bacpac
*.dump
*.mdf
*.ldf
*.ndf
*.sql.gz

# Power BI files with embedded data
*.pbix

# Build output / tooling
bin/
obj/
.vs/
node_modules/
```

If a project legitimately versions a `.pbix` or similar, override it in that repo with `git add -f` or a `!` rule.


### 4.6 Sharing the Git and SSH setup with Debian on WSL

**Windows is the single source of truth; WSL reads it.** Repositories stay in `C:\Work` (seen as `/mnt/c/Work` from WSL), so there is still one tree, one set of identity rules and one NAS sync.

| What | Lives in | How WSL uses it |
|------|----------|-----------------|
| Git shared config, include files, global ignore | `%USERPROFILE%\.gitconfig.d\`, `%USERPROFILE%\.gitignore_global` | symlinks in the WSL home |
| SSH private keys and agent | Windows (`%USERPROFILE%\.ssh`, Windows `ssh-agent` service) | Git in WSL runs Windows' `ssh.exe` |
| SSH `config` and `known_hosts` | `%USERPROFILE%\.ssh` | read directly by `ssh.exe` |
| Repositories | `C:\Work` | `/mnt/c/Work` |

The private keys never leave Windows, so there are no duplicated secrets and no permission problems.

**1. Windows: run the agent and load the keys once** (the first command needs an elevated PowerShell). Keys added to the Windows agent persist across reboots.

```powershell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519_main
ssh-add $env:USERPROFILE\.ssh\id_ed25519_metra
ssh-add $env:USERPROFILE\.ssh\id_ed25519_codiceplastico
ssh-add -l
```

**2. WSL (Debian): link the shared files and add the stub**

```bash
WINHOME=$(cd /mnt/c && wslpath "$(cmd.exe /c 'echo %USERPROFILE%' 2>/dev/null | tr -d '\r')")
ln -s "$WINHOME/.gitconfig.d"      ~/.gitconfig.d
ln -s "$WINHOME/.gitignore_global" ~/.gitignore_global

cat > ~/.gitconfig <<'EOT'
[include]
    path = ~/.gitconfig.d/shared.inc

[core]
    sshCommand = ssh.exe
EOT
```

The shared file is identical on both systems because `~/` expands to each OS's own home, and the `includeIf` rules already list both `C:/Work/...` and `/mnt/c/Work/...`.

**3. Verify from WSL**

```bash
cd /mnt/c/Work/Metra/repos/<repo>
git config user.email                  # a.turelli@metra.it
git config --show-origin user.email    # shows which include file won
ssh.exe -T git@github.com-metra        # should greet the Metra account
git fetch
```

Caveats:

- **Only Git uses `ssh.exe`.** A plain `ssh`, `scp` or `rsync -e ssh` typed in WSL runs the Linux client, which has no keys. If you need those (e.g. `rsync` to the NAS), bridge the Windows agent into WSL instead of copying keys (the Windows agent is exposed as a named pipe; `npiperelay` and `socat` forward it to a Unix socket):

  ```bash
  sudo apt install socat
  # npiperelay.exe must be installed on Windows and be on the PATH (e.g. via winget; check the exact package name)
  # ~/.bashrc
  export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
  if ! ss -a | grep -q "$SSH_AUTH_SOCK"; then
    rm -f "$SSH_AUTH_SOCK"
    (setsid socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
  fi
  ```

  Linux `ssh` then also needs its own `~/.ssh/config` and the **public** keys (`*.pub`) in `~/.ssh`; with `IdentitiesOnly yes` it selects the matching key from the agent. **Copy** the config instead of symlinking it: OpenSSH refuses config and key files with loose permissions, and files under `/mnt/c` normally look world-accessible.
- **Do not copy the private keys into WSL** unless you have to. If you do, `chmod 600` them and remember you now have two places to protect and revoke.
- **Speed.** Git on `/mnt/c` is much slower than on the WSL file system, noticeable on large repositories. It is fine for day-to-day use. For heavy Linux-side work you can clone into the WSL home (e.g. `~/work/Metra/...`), but those clones fall outside `C:\Work` and the NAS sync, and need their own rule, e.g. `[includeIf "gitdir/i:~/work/Metra/"]` in `shared.inc` (harmless on Windows).
- **File modes.** If `git status` in WSL flags every file in a `/mnt/c` repo as changed, run `git config core.fileMode false` in that repo.
- **Line endings.** Git for Windows may default to `core.autocrlf=true`, while Git in WSL does not. Add a `.gitattributes` (for instance `* text=auto`, plus `*.sh text eol=lf`) to each repo so SQL and shell scripts do not mix CRLF/LF.
- **Interop must be enabled** in WSL (it is by default) for `ssh.exe` to be found. If Git in WSL cannot find it, check `which ssh.exe` and `[interop]` in `/etc/wsl.conf`.

---

## 5. Documents: detecting changes between deliveries

`documents\` is not versioned in any remote, but you still want "what changed since last time". Two complementary techniques:

1. **Dated snapshots (works for any file type, including Excel/PDF).** Files arrive in `inbox\` with the receipt date as prefix; produced files go in `exports\<yyyy-MM-dd>\`. Comparing two deliveries means comparing two named files or folders.
2. **A local-only Git repo for text data (optional).** For CSV/JSON/XML/SQL you can `git init` inside `documents\ingestion` (and/or `exports`), never add a remote, and commit after each delivery. `git diff` then shows row-level changes. Keep it local: its content is customer data, so it only travels through the NAS sync, which is on your own network.

Do not put customer data in a repository with a remote (GitHub, Azure DevOps...) unless the customer explicitly agrees.

---

## 6. Docker: containers, volumes and the backups

### 6.1 Naming and ports

Use `COMPOSE_PROJECT_NAME=<workspace>-<project>` (in `.env`) so containers, networks and volumes are automatically prefixed and never collide across customers (`a2a-dwh-sql-1`, `metra-reporting_sqldata`, ...).

Give every workspace a fixed host-port block, so several customers' SQL Server containers can run at the same time and every connection string is predictable:

| Workspace | SQL Server host port |
|-----------|----------------------|
| `1729` | 14330 |
| `CesiMultimedia` | 14331 |
| `Metra` | 14332 |
| `CodicePlastico\A2A` | 14333 |
| `CodicePlastico\Berg` | 14334 |
| `CodicePlastico\NSA` | 14335 |
| `CodicePlastico\FraternitaSistemi` | 14336 |

If a workspace needs more services, use the same index in another range (e.g. 15331 for a second service of `CesiMultimedia`). Record the ports in the customer card.

### 6.2 Where the data lives

| Kind of data | Where | Why |
|--------------|-------|-----|
| SQL Server data files | **Named volume** (inside Docker's WSL 2 disk) | Fast and reliable. SQL Server data files on a Windows bind mount are slow and problematic. |
| Backups (`.bak`, `.bacpac`) | **Bind mount** to `<workspace>\backups\sqlserver` | Visible in Windows Explorer, easy to sync. |
| Files to ingest / produced exports | **Bind mount** to `<workspace>\documents\ingestion` / `exports` | The containers read and write the same files you review on the host. |

Example fragment of `compose.yaml`:

```yaml
services:
  sql:
    image: mcr.microsoft.com/mssql/server:2025-latest
    ports:
      - "14333:1433"
    environment:
      ACCEPT_EULA: "Y"
      MSSQL_SA_PASSWORD: ${MSSQL_SA_PASSWORD}
    volumes:
      - sqldata:/var/opt/mssql                              # data: named volume
      - ../../backups/sqlserver:/var/opt/mssql/backup       # .bak: visible on the host
      - ../../documents/ingestion:/data/ingestion:ro        # input files
      - ../../documents/exports:/data/exports               # outputs

volumes:
  sqldata:
```

(Relative paths are resolved from the stack folder, i.e. `<workspace>\docker\<stack>\`. Check the exact SQL Server image tag you use; the one above is an example.)

### 6.3 Backing up what lives in named volumes

Because named volumes are not ordinary Windows folders, "sync the Docker volumes" really means *export them to files* first:

- **Databases**: `BACKUP DATABASE ... TO DISK = '/var/opt/mssql/backup/<db>_<yyyyMMdd-HHmm>_FULL.bak'` lands directly in `backups\sqlserver`. For schema+data portability use a `.bacpac` export into `backups\bacpac`.
- **Any other volume**:

  ```powershell
  # Export a named volume to backups\docker-volumes as a dated tarball
  $vol  = "a2a-dwh_sqldata"
  $dest = "C:\Work\CodicePlastico\A2A\backups\docker-volumes"
  docker run --rm -v "${vol}:/src:ro" -v "${dest}:/dst" alpine `
    tar czf "/dst/${vol}_$(Get-Date -Format yyyyMMdd).tar.gz" -C /src .
  ```

  For a transactionally consistent copy of a SQL Server volume, stop the container first, or rely on the `.bak` instead of the tarball.

Prefer `.bak`/`.bacpac` for databases and use volume tarballs for everything else (configuration, Redis/Mongo data, etc.).

### 6.4 Backup file names and local retention

```text
<database>_<yyyyMMdd-HHmm>_<FULL|DIFF|LOG>.bak
<database>_<yyyyMMdd-HHmm>.bacpac
```

`backups\` is a staging area on a 1 TB SSD. Suggested policy: keep the latest 2–3 per database locally; older ones live only on the NAS. Never delete a local backup before verifying it exists on the NAS (see §7).

---

## 7. Weekly NAS sync

### 7.1 NAS layout mirrors the laptop

The NAS exposes the share `\\NAS-1729\Work`. The weekly sync writes **only** into its `Git` folder and reproduces there the exact folder structure of `C:\Work`:

```text
\\NAS-1729\Work\
├── Git\                                   ← target of the weekly sync (and ONLY this folder)
│   ├── 1729\
│   │   └── repos\
│   │       └── work-laptop.git            ← bare mirror of C:\Work\1729\repos\work-laptop
│   ├── CesiMultimedia\
│   │   ├── documents\...                  ← plain copy of C:\Work\CesiMultimedia\documents
│   │   ├── backups\...                    ← plain copy
│   │   └── repos\
│   │       └── Cesi.git                   ← bare mirror of C:\Work\CesiMultimedia\repos\Cesi
│   └── CodicePlastico\A2A\ ...
├── _old\                                  ← NOT managed by the sync: never touched
├── _Archive\                              ← NOT managed by the sync: never touched
└── @Recycle, @Recently-Snapshot           ← NAS system folders
```

Because both sides share the same relative structure, a path on the NAS is the laptop path with `\\NAS-1729\Work\Git` in front of it, and a repository `X` becomes `X.git`. The same script handles every workspace: there is no per-customer list to maintain.

> The optional copy of the Google Drive invoices (§8) is outside the weekly sync described here.

### 7.2 Sync policy

[`scripts/Sync-Work.ps1`](../../scripts/Sync-Work.ps1) walks the whole of `C:\Work` once and treats every folder in one of two ways:

| What | How it is synced | Notes |
|------|------------------|-------|
| **Git repositories** (any folder that contains `.git`, wherever it is: `repos\`, but also e.g. `docker\odoo`) | `git push --mirror` to a bare `<name>.git` at the same relative path under `Git\`. The bare repository is created on the first run. | A working tree is never copied while it can change. **Uncommitted and untracked files, and ignored files (`.env`, local data), are not saved**: the script lists the repositories that have uncommitted work. Commits that are not on any remote *are* saved. |
| **Everything else** (`documents`, `backups`, shortcuts, `README.md` cards, ...) | `robocopy /E`: new and changed files are copied. | **No deletions on the NAS** (no `/MIR`, no `/PURGE`): a file deleted or renamed locally stays on the NAS. |

Excluded from both: `docker_volumes` (raw Docker volume data: copying live database files gives corrupt backups, see §6.3 for how to export them), and the folders named `node_modules`, `$RECYCLE.BIN` and `System Volume Information`. `Thumbs.db` and Office lock files (`~$*`) are skipped. Change the defaults in the `param()` block of the script, or pass `-ExcludePath`, `-ExcludeDirectory`, `-ExcludeFile`.

Notes:

- Deleted local branches/tags **are** removed from the NAS mirror (that is what a mirror is); the objects remain in the bare repository until it is garbage-collected, and the NAS snapshots protect the rest. A repository without any commit is skipped, so an empty clone can never erase an existing mirror.
- Pre-push hooks of the repositories are not run (`--no-verify`). Git LFS objects and submodule contents are not part of a mirror.
- If the NAS supports snapshots (e.g. Btrfs/ZFS), keep them enabled on the share: they protect against ransomware and against overwriting good files with bad ones.
- For stronger guarantees (deduplication, encryption, point-in-time restore) consider `restic` or `rclone` instead of `robocopy`.

### 7.3 Safety rules built into the script

- It writes **only** to `\\NAS-1729\Work\Git`. `_old`, `_Archive`, `@Recycle` and `@Recently-Snapshot` are never touched, and the script refuses a destination folder named like a protected folder (starting with `_` or `@`).
- The `Git` folder must already exist; it is never created automatically, so a typo cannot create a stray folder on the NAS.
- It refuses to run when the NAS is unreachable (it retries 3 times, one minute apart, to survive a laptop that wakes up before the network), when the source is missing or empty, or when another instance is already running.
- Junctions and symbolic links are not followed.
- `-WhatIf` lists what would be copied and mirrored without writing anything on the NAS.
- Logs go to `%LOCALAPPDATA%\Sync-Work\logs` (never inside `C:\Work`, so they are not synced): a summary log and the full `robocopy` log of each run, kept for 90 days.
- Exit code `0` = OK, `1` = completed with errors (Task Scheduler shows a failure), `2` = could not start, `3` = already running. `robocopy` codes 0-7 count as success, 8 and above as errors.

### 7.4 First run

1. **Make the NAS credentials available without a prompt** (the scheduled task runs as you, with your Windows Credential Manager):

   ```powershell
   cmdkey /add:NAS-1729 /user:<nas-user> /pass:<password>
   dir \\NAS-1729\Work     # must list Git, _old, _Archive without asking for credentials
   ```

2. **Dry run.** Nothing is written to the NAS:

   ```powershell
   cd C:\Work\1729\repos\work-laptop
   .\scripts\Sync-Work.ps1 -WhatIf
   ```

   Check the repository list, the `robocopy` list (the first run copies everything) and the warnings about uncommitted work.

   If PowerShell refuses to run scripts: `pwsh -ExecutionPolicy Bypass -File .\scripts\Sync-Work.ps1 -WhatIf` (or set `RemoteSigned` as in [`scripts/README.md`](../../scripts/README.md)).

3. **First real run.** It can take a long time (the whole of `C:\Work` goes over the network):

   ```powershell
   .\scripts\Sync-Work.ps1
   ```

4. **Run it a second time**: it must be quick and copy almost nothing.

### 7.5 Weekly schedule

```powershell
# Registers a Scheduled Task for the current user: every Sunday at 12:00
.\scripts\Sync-Work.ps1 -RegisterTask -WhatIf                     # preview
.\scripts\Sync-Work.ps1 -RegisterTask -TaskDay Sunday -TaskTime 12:00

Start-ScheduledTask -TaskName Sync-Work-To-NAS                    # test it now
Get-ScheduledTaskInfo -TaskName Sync-Work-To-NAS                  # LastRunTime, LastTaskResult (0 = OK)
```

The task runs under Windows PowerShell 5.1 as the logged-on user, with no stored password. If the laptop is off at the scheduled time, it runs as soon as possible afterwards, only when the network is available, and a second run never starts while the first one is still working. Because it runs only while you are logged on, keep the laptop on and signed in (or locked) on Sunday at noon; a missed run starts as soon as you sign in again. To change the schedule, run the command again (the task is updated); to remove it: `Unregister-ScheduledTask -TaskName Sync-Work-To-NAS`.

Check the latest log from time to time (`%LOCALAPPDATA%\Sync-Work\logs`), and run a `-WhatIf` first after every change of the layout.

### 7.6 Restore

- **Files**: copy them back from `\\NAS-1729\Work\Git\<path>` to `C:\Work\<path>`.
- **A repository**: `git clone \\NAS-1729\Work\Git\<path>\<repo>.git C:\Work\<path>\<repo>`. The clone has all branches and tags; set the original `origin` URL again afterwards (`git remote set-url origin ...`). Work that was uncommitted at the last sync is lost.
- If git refuses to read the share with "dubious ownership" (the share belongs to another account), allow that one mirror, as git suggests: `git config --global --add safe.directory '\\NAS-1729\Work\Git\<path>\<repo>.git'`. Note that `git -c safe.directory=...` does **not** work for `clone` and `push`, because git does not hand `-c` to the second git process it starts for the other repository. `Sync-Work.ps1` solves this with a private git config file (`GIT_CONFIG_GLOBAL`) used only for its pushes to the NAS, so your own `~/.gitconfig` is left untouched.

---

## 8. Invoices on Google Drive

Invoices are organised by the **billing entity**, which is why the three top-level names are the same as in `C:\Work`. The accountant normally wants them by year, so the year goes first.

```text
Google Drive\
└── Invoices\
    └── 2026\
        ├── Issued\                          ← fatture emesse
        │   ├── CesiMultimedia\
        │   │   └── 2026-03-31_CesiMultimedia_2026-007.pdf
        │   ├── Metra\
        │   └── CodicePlastico\              ← ONE invoice for the software house,
        │       ├── 2026-03-31_CodicePlastico_2026-008.pdf       whatever the end customer
        │       └── Timesheets\
        │           ├── A2A\
        │           ├── Berg\
        │           ├── NSA\
        │           └── FraternitaSistemi\   ← the breakdown per end customer
        ├── Received\                        ← fatture ricevute (software, hardware, services)
        └── _ForAccountant\                  ← exports/packages sent to the accountant
```

Conventions:

- File name: `<yyyy-MM-dd>_<BillingEntity>_<YYYY>-<number>.pdf` (ISO date first so the folder sorts chronologically).
- The per-end-customer **timesheets** support the CodicePlastico invoice; they belong next to it, not in the customer's workspace (they are an administrative document, not project data).
- Keep this folder **out of `C:\Work`**: it holds financial data with a different retention (Italian rules require keeping invoices for years) and a different audience (the accountant).
- Optional: `rclone copy "gdrive:Invoices" \\NAS-1729\Work\GoogleDrive\Invoices` for a second copy outside Google. Use a folder of its own, outside the `Git` target of the weekly sync, and outside `_old` and `_Archive`.

---

## 9. Life cycle

| Event | Action |
|-------|--------|
| **New direct customer** | Run `scripts\New-Customer.ps1` (creates the four standard folders and the customer card; it never touches `.gitconfig`). Add an `includeIf` + include file if it needs another Git identity. Assign a SQL port (written in the card). The NAS sync picks the new folder up by itself. Create `Invoices\<year>\Issued\<Customer>` on Drive. |
| **New end customer of CodicePlastico** | Run `scripts\New-Customer.ps1 -Type EndCustomer -Parent CodicePlastico` (the Git identity is already inherited). Add `Timesheets\<Client>` on Drive. |
| **New repo** | `git clone` into `<workspace>\repos\<repo-name>`. Run the audit (§4.4) once to confirm the e-mail. |
| **Engagement ends** | Run a last sync, verify the NAS copy, then move the whole folder to `C:\Work\_Archive\<year>\<Workspace>` and remove stale Docker volumes (`docker compose down -v`) **after** exporting what you need. Respect the retention required by the contract/NDA, and delete customer data when the contract says so. |
| **New laptop** | Install the tools (rest of this guide), restore `~/.gitconfig*` and SSH keys (from Bitwarden or an encrypted backup), clone the repos from the remotes or from the bare mirrors in `\\NAS-1729\Work\Git`, copy `documents`/`backups` back from the same folder (see §7.6). |

---

## 10. Security checklist

- [ ] BitLocker enabled on the laptop SSD (customer data lives in `documents` and `backups`).
- [ ] The NAS share `\\NAS-1729\Work` is encrypted and not exposed to the Internet.
- [ ] Secrets only in Bitwarden and local `.env` files; `.env.sample` is the only thing committed.
- [ ] Global ignore (§4.5) in place; `.bak`/`.bacpac`/`.pbix` never reach a remote by accident.
- [ ] One SSH key per Git account, `IdentitiesOnly=yes`.
- [ ] Identity audit (§4.4) run after each new clone and before each weekly sync.
- [ ] Customer data from one workspace is never copied to another workspace, nor used in a different customer's containers.
- [ ] Production data restored locally is anonymised/masked when the customer requires it, and removed when it is no longer needed.

---

## 11. Suggested adoption order

1. Create `C:\Work` and the workspace skeletons (`scripts\New-Customer.ps1` does it).
2. Configure Git (§4): global config, include files, global ignore, SSH keys. Run the audit.
3. Move existing repositories from `C:\Work.Git\...` to their new `repos\` folders (`git` repositories can simply be moved; re-run the audit afterwards).
4. Standardise one Docker stack (e.g. `a2a-dwh`) with the §6 pattern and replicate it.
5. Reorganise Google Drive invoices into the §8 structure.
6. Run `Sync-Work.ps1 -WhatIf`, then a real run and a second run (§7.4), and only then schedule it with `-RegisterTask` (§7.5).
