# Additional Development Tools Installation

This guide covers installing additional development tools required for BI development and cloud integration.

## Tools Covered

1. **PowerShell 7** - Modern PowerShell cross-platform shell
2. **Windows Subsystem for Linux (WSL)** - Linux environment on Windows
3. **Docker Desktop** - Container platform integrated with WSL
4. **DBeaver Community Edition** - Universal database management tool
5. **Google Cloud CLI** - Google Cloud Platform command-line tools
6. **Google Cloud SQL Proxy** - Secure database connections to Cloud SQL

---

## 🔷 PowerShell 7

### Overview
PowerShell 7 is the latest version of PowerShell, offering cross-platform support and modern features.

### Installation via Microsoft Store (Recommended)

1. **Open Microsoft Store**
   - Press `Win + S` and search for "Microsoft Store"
   - Or click Start → Microsoft Store

2. **Search for PowerShell**
   - In Microsoft Store, search for "PowerShell"
   - Select **PowerShell** (by Microsoft Corporation)
   - Current version: PowerShell 7.x

3. **Install**
   - Click **Get** or **Install**
   - Wait for installation to complete
   - No restart required

### Verification

```powershell
# Check version
pwsh --version

# Or launch PowerShell 7 and check
pwsh
$PSVersionTable
```

### Configuration

1. **Set as Default Terminal**
   - Windows Terminal → Settings → Startup
   - Default Profile: PowerShell 7

2. **Install PowerShell Modules** (as needed)
   ```powershell
   # SQL Server module
   Install-Module -Name SqlServer -Scope CurrentUser

   # Azure modules
   Install-Module -Name Az -Scope CurrentUser

   # Active Directory module (requires RSAT)
   Install-Module -Name ActiveDirectory -Scope CurrentUser
   ```

### Updates

PowerShell 7 installed from Microsoft Store updates automatically through Windows Store updates.

---

## 🐧 Windows Subsystem for Linux (WSL)

### Overview
WSL allows running Linux distributions natively on Windows, useful for Linux-based tools and development environments.

### Installation via Microsoft Store (Recommended)

#### Method 1: Command Line Installation

1. **Open PowerShell as Administrator**
   - Right-click Start → Windows Terminal (Admin)

2. **Install WSL**
   ```powershell
   wsl --install
   ```

3. **Restart Computer**
   - Required after first-time WSL installation

4. **Install Linux Distribution**
   - After restart, choose a distribution:
   ```powershell
   # List available distributions
   wsl --list --online

   # Install Ubuntu (recommended)
   wsl --install -d Ubuntu-22.04
   ```

#### Method 2: Microsoft Store Installation

1. **Enable WSL Feature First**
   ```powershell
   # Run as Administrator
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

2. **Restart Computer**

3. **Install from Microsoft Store**
   - Open Microsoft Store
   - Search for "Ubuntu" or "Debian" or preferred distribution
   - Click **Get** to install
   - Launch and complete initial setup (create user and password)

### Initial Configuration

1. **Set WSL 2 as Default** (if not already)
   ```powershell
   wsl --set-default-version 2
   ```

2. **Update WSL Kernel**
   ```powershell
   wsl --update
   ```

3. **Configure Ubuntu/Linux**
   ```bash
   # Update package lists
   sudo apt update
   sudo apt upgrade -y

   # Install common tools
   sudo apt install -y git curl wget build-essential
   ```

### Verification

```powershell
# Check WSL version
wsl --version

# List installed distributions
wsl --list --verbose

# Check Linux is running
wsl uname -a
```

### Useful WSL Commands

```powershell
# Start default distribution
wsl

# Start specific distribution
wsl -d Ubuntu-22.04

# Shutdown WSL
wsl --shutdown

# Terminate specific distribution
wsl --terminate Ubuntu-22.04
```

---

## 🐳 Docker Desktop

### Overview
Docker Desktop provides container platform integrated with WSL 2, essential for modern development workflows.

**Prerequisites**: WSL 2 must be installed first

### Installation

1. **Download Docker Desktop**
   - Visit: [https://www.docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop)
   - Click **Download for Windows**
   - File: `Docker Desktop Installer.exe`

2. **Run Installer**
   - Right-click installer → **Run as administrator**
   - Ensure "Use WSL 2 instead of Hyper-V" is checked
   - Click **OK**
   - Wait for installation (5-10 minutes)

3. **Restart Computer** (required)

4. **First Launch**
   - Launch Docker Desktop from Start Menu
   - Accept service agreement
   - Optional: Sign in with Docker Hub account (or skip)
   - Docker Desktop will start WSL integration automatically

### Configuration

1. **WSL Integration**
   - Docker Desktop → Settings → Resources → WSL Integration
   - Enable integration with Ubuntu or your installed distribution
   - Click **Apply & Restart**

2. **Resource Limits** (optional)
   - Settings → Resources → Advanced
   - Adjust CPU, Memory limits if needed
   - Docker Desktop uses WSL 2 backend (efficient resource usage)

### Verification

```powershell
# Check Docker version
docker --version

# Run test container
docker run hello-world

# Check Docker Compose
docker-compose --version
```

```bash
# From WSL Ubuntu
docker ps
docker images
```

### Useful Docker Commands

```powershell
# List running containers
docker ps

# List all containers
docker ps -a

# List images
docker images

# Pull SQL Server container (example)
docker pull mcr.microsoft.com/mssql/server:2022-latest
```

### Updates

- Docker Desktop checks for updates automatically
- Settings → Software updates → Check for updates
- Or download latest installer and run

---

## 🗄️ DBeaver Community Edition

### Overview
DBeaver is a universal database management tool supporting SQL Server, PostgreSQL, MySQL, and many others.

### Installation

1. **Download DBeaver**
   - Visit: [https://dbeaver.io/download/](https://dbeaver.io/download/)
   - Select **Windows (installer)**
   - Download: `dbeaver-ce-latest-x86_64-setup.exe`

2. **Run Installer**
   - Run the downloaded installer
   - Click **Next** through wizard
   - Accept license agreement
   - Choose installation location (default is fine)
   - Select "Create Desktop Icon" if desired
   - Click **Install**
   - Click **Finish**

### Alternative: Portable Version

- Download **Windows (zip archive)** for portable installation
- Extract to desired location (e.g., `C:\Tools\DBeaver`)
- Run `dbeaver.exe`

### Initial Configuration

1. **Launch DBeaver**
   - Start Menu → DBeaver

2. **Create Database Connections**
   - Click **New Database Connection** or **Database → New Database Connection**
   - Select database type:
     - **SQL Server** - For Microsoft SQL Server
     - **PostgreSQL** - For PostgreSQL databases
     - **MySQL** - For MySQL databases
     - **Google Cloud SQL** - Supported

3. **Install Database Drivers**
   - DBeaver will prompt to download drivers on first connection
   - Click **Download** to get JDBC drivers
   - Drivers are cached locally

### SQL Server Connection Example

1. **New Connection → SQL Server**
2. **Connection Settings**:
   - Host: `localhost` or server name
   - Port: `1433`
   - Database: `master` or specific database
   - Authentication: Windows or SQL Server
   - Username/Password (if SQL Server auth)
3. **Test Connection**
4. **Finish**

### Google Cloud SQL Connection

1. **New Connection → Google Cloud SQL**
2. **Use Cloud SQL Proxy** (see Google Cloud SQL Proxy section)
3. **Connection Settings**:
   - Host: `127.0.0.1` (via proxy)
   - Port: `3306` (MySQL) or `5432` (PostgreSQL)
   - Database, Username, Password from Cloud SQL

### Updates

- Help → Check for Updates
- Or download latest installer and reinstall

---

## ☁️ Google Cloud CLI (gcloud)

### Overview
Google Cloud CLI provides command-line tools for Google Cloud Platform services, including Cloud SQL.

### Installation

1. **Download Google Cloud SDK**
   - Visit: [https://cloud.google.com/sdk/docs/install](https://cloud.google.com/sdk/docs/install)
   - Click **Download the Cloud SDK installer** for Windows
   - Download: `GoogleCloudSDKInstaller.exe`

2. **Run Installer**
   - Run the downloaded installer
   - Click **Yes** on UAC prompt
   - Choose installation options:
     - ✅ Install bundled Python (recommended)
     - ✅ Run 'gcloud init' after installation
   - Click **Install**

3. **Initialize gcloud**
   - After installation, gcloud init will run automatically
   - Or run manually:
     ```powershell
     gcloud init
     ```

4. **Login to Google Cloud**
   - Browser window will open
   - Sign in with Google account
   - Grant permissions to Google Cloud SDK
   - Return to terminal

5. **Configure Default Project**
   - Select or create Google Cloud project
   - Set default region/zone (optional)

### Verification

```powershell
# Check gcloud version
gcloud --version

# Check authenticated account
gcloud auth list

# List projects
gcloud projects list
```

### Install Additional Components

```powershell
# Install Cloud SQL Proxy
gcloud components install cloud-sql-proxy

# Install kubectl (if using GKE)
gcloud components install kubectl

# Update components
gcloud components update
```

### Configuration

```powershell
# Set default project
gcloud config set project PROJECT_ID

# Set default region
gcloud config set compute/region us-central1

# View configuration
gcloud config list
```

---

## 🔌 Google Cloud SQL Proxy

### Overview
Cloud SQL Proxy provides secure access to Cloud SQL instances without configuring firewall rules or SSL.

### Installation via gcloud

```powershell
# Install via gcloud components
gcloud components install cloud-sql-proxy
```

### Alternative: Download Binary

1. **Download**
   - Visit: [https://cloud.google.com/sql/docs/mysql/sql-proxy#install](https://cloud.google.com/sql/docs/mysql/sql-proxy#install)
   - Download Windows binary: `cloud-sql-proxy.exe`

2. **Save to PATH Location**
   ```powershell
   # Example: Save to a tools directory
   New-Item -Path "C:\Tools\CloudSQL" -ItemType Directory -Force
   # Move cloud-sql-proxy.exe to C:\Tools\CloudSQL
   
   # Add to PATH (PowerShell)
   $env:Path += ";C:\Tools\CloudSQL"
   
   # Or add permanently via System Properties → Environment Variables
   ```

### Usage

#### Start Proxy for Cloud SQL Instance

```powershell
# Basic usage - PostgreSQL example
cloud-sql-proxy PROJECT_ID:REGION:INSTANCE_NAME

# MySQL example with specific port
cloud-sql-proxy --port=3306 PROJECT_ID:REGION:INSTANCE_NAME

# Multiple instances
cloud-sql-proxy PROJECT_ID:REGION:INSTANCE_1 PROJECT_ID:REGION:INSTANCE_2
```

#### Example: Connect to Cloud SQL via Proxy

```powershell
# Start proxy (keep this terminal open)
cloud-sql-proxy --port=5432 my-project:us-central1:my-postgres-instance

# In another terminal/tool, connect to localhost:5432
# Example with psql:
psql -h 127.0.0.1 -p 5432 -U myuser -d mydatabase
```

#### Use with DBeaver

1. **Start Cloud SQL Proxy** in terminal
   ```powershell
   cloud-sql-proxy --port=5432 PROJECT_ID:REGION:INSTANCE_NAME
   ```

2. **In DBeaver**
   - Create new PostgreSQL connection
   - Host: `127.0.0.1` or `localhost`
   - Port: `5432` (or port specified in proxy)
   - Database, Username, Password from Cloud SQL

### Authentication

Cloud SQL Proxy uses gcloud authentication:

```powershell
# Ensure you're logged in
gcloud auth login

# Application default credentials (for tools)
gcloud auth application-default login
```

---

## ✅ Verification Checklist

After installing all tools:

- [ ] PowerShell 7 installed and launches (`pwsh --version`)
- [ ] WSL 2 installed (`wsl --version`)
- [ ] Ubuntu (or chosen distribution) running in WSL
- [ ] Docker Desktop installed and running (`docker --version`)
- [ ] Docker integrated with WSL (can run `docker ps` from Ubuntu)
- [ ] DBeaver installed and launches
- [ ] Google Cloud CLI installed (`gcloud --version`)
- [ ] Authenticated to Google Cloud (`gcloud auth list`)
- [ ] Cloud SQL Proxy available (`cloud-sql-proxy --version`)

---

## 🔗 Related Documentation

- **Updates**: See [Periodic Updates Guide](../configuration/periodic-updates.md)
- **Next Steps**: Continue with SQL Server installation

---

**Created**: May 27, 2026  
**Laptop**: Dell XPS 13 9310 (MIRZAKHANI)  
**Purpose**: Additional development tools for BI and cloud development
