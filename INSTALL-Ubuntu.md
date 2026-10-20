# Ubuntu 26.10 on a Dell XPS 13

This guide installs Ubuntu Desktop 26.10 and a development workstation toolset on a Dell XPS 13. It was prepared on October 17, 2026. Use the vendors' current download pages if a package version or filename has changed.

> **Release choice:** Ubuntu 26.10 is an interim release with a shorter support window than an LTS release. Choose it if you specifically want the newest Ubuntu; choose Ubuntu 26.04 LTS instead if long-term stability and support are more important.

## 1. Check the laptop and protect your data

1. Identify the exact XPS 13 model and processor in BIOS or Dell Support. The Ubuntu Desktop ISO below is for **64-bit AMD64/x86-64** systems. Do not use it for an ARM-based XPS model.
2. Back up files and verify that the backup can be read. If keeping Windows or dual-booting, save the BitLocker recovery key and make sure you understand the installer choices. **“Erase disk” removes Windows and all data on the selected disk.**
3. Connect AC power. Install available BIOS/firmware updates from Dell before installing Ubuntu, and record any customized BIOS settings.
4. Have Wi-Fi or a wired network available. Keep Secure Boot enabled unless Dell or Ubuntu troubleshooting guidance for your exact model requires changing it.

## 2. Download Ubuntu and make a bootable USB

1. From a working computer, open the [official Ubuntu 26.10 release page](https://releases.ubuntu.com/26.10/).
2. Download **64-bit PC (AMD64) desktop image** (`ubuntu-26.10-desktop-amd64.iso`). Do not choose the Server, WSL, or ARM image.
3. Verify the ISO against the `SHA256SUMS` file linked from the same release page. On Windows PowerShell, for example:

   ```powershell
   Get-FileHash .\ubuntu-26.10-desktop-amd64.iso -Algorithm SHA256
   ```

   Compare the displayed hash with the entry for that ISO in `SHA256SUMS`.
4. Use [Rufus](https://rufus.ie/) to write the ISO to an 8 GB or larger USB drive. This erases the USB drive. Accept Rufus's recommended settings for the downloaded Ubuntu ISO.

## 3. Install Ubuntu

1. Shut down the XPS 13, insert the USB, power on, and tap **F12** at the Dell logo to open the one-time boot menu. Choose the UEFI USB entry.
2. Select **Try or Install Ubuntu** and, if offered, try the live desktop first. Check Wi-Fi, keyboard, touchpad, audio, display brightness, camera, and suspend/resume.
3. Start **Install Ubuntu**. Select the appropriate keyboard, network, and installation options. Installing updates and third-party drivers during setup is generally useful when the network is available.
4. At the disk screen:
   - For Ubuntu only, select **Erase disk and install Ubuntu** only after confirming the target disk and that your backup is complete.
   - For dual boot, select the installer’s alongside-Windows option if available. If Windows BitLocker prevents the installer from safely resizing the disk, stop and follow Ubuntu’s current dual-boot/BitLocker guidance; do not guess at partitions.
   - If enabling disk encryption, save the recovery information somewhere other than this laptop.
5. Complete the user and time-zone setup. When prompted, remove the USB and restart.

After the first login, connect to the network and install all Ubuntu updates:

```bash
sudo apt update
sudo apt full-upgrade
sudo reboot
```

## 4. Install Ubuntu repository development tools

Open **Terminal** and install Git, database command-line clients, a practical LaTeX setup, and Tilix:

```bash
sudo apt install git mariadb-client postgresql-client \
  texlive-latex-base texlive-latex-recommended texlive-fonts-recommended \
  latexmk tilix
```

This installs the default PostgreSQL client supplied for this Ubuntu release. To use a different PostgreSQL major version, install the matching client package from the official PostgreSQL repository instead.

Optional, larger TeX Live components:

```bash
sudo apt install texlive-latex-extra texlive-xetex
```

Check the tools:

```bash
git --version
mariadb --version
psql --version
pdflatex --version
latexmk --version
```

### Screenfetch and BOFH fortunes

These older utility packages can vary by Ubuntu release. Search the enabled Ubuntu repositories before installing:

```bash
apt-cache search screenfetch
apt-cache search bofh
```

If `screenfetch` is listed, install and run it:

```bash
sudo apt install screenfetch
screenfetch
```

For BOFH excuses, install `fortune-mod` and the BOFH package name shown by `apt-cache search bofh` (commonly `fortunes-bofh-excuses`):

```bash
sudo apt install fortune-mod fortunes-bofh-excuses
fortune bofh-excuses
```

If either package is not present in the 26.10 repositories, do not install an unrelated old `.deb` from a third-party mirror. Check the [Ubuntu package search](https://packages.ubuntu.com/) for the `stonking` suite; `screenfetch` is unmaintained, so consider `fastfetch` if it is unavailable.

## 5. Install Docker Engine

Docker's current Ubuntu instructions list Ubuntu 26.10. Use Docker's signed APT repository so that normal package updates can update Docker:

```bash
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
```

Use Docker with `sudo` initially. Adding your account to the `docker` group allows it to effectively gain root-level control of the machine; only do so if you understand and accept that risk. Docker-published container ports can also bypass UFW firewall rules; review Docker's [firewall guidance](https://docs.docker.com/engine/network/packet-filtering-firewalls/) before exposing services.

## 6. Install desktop applications

Use official vendor sources and download the Linux **Ubuntu/Debian AMD64** package when a `.deb` is offered. Since the Downloads directory may not be accessible to APT's unprivileged `_apt` user, stage each package in `/tmp` with readable permissions, then install it with `apt`. For example:

```bash
sudo install -m 0644 ~/Downloads/<downloaded-file>.deb /tmp/<downloaded-file>.deb
sudo apt install /tmp/<downloaded-file>.deb
```

Replace both placeholders with the package's actual filename.

### Google Chrome

Download the stable Linux `.deb` from [Google Chrome](https://www.google.com/chrome/), then stage and install it:

```bash
sudo install -m 0644 ~/Downloads/google-chrome-stable_current_amd64.deb \
  /tmp/google-chrome-stable_current_amd64.deb
sudo apt install /tmp/google-chrome-stable_current_amd64.deb
```

The installer normally configures Google's package source for Chrome updates.

### Slack

Download the Linux `.deb` from [Slack for Linux](https://slack.com/downloads/linux), then stage and install it (substitute the actual downloaded filename):

```bash
sudo install -m 0644 ~/Downloads/<slack-downloaded-filename>.deb \
  /tmp/<slack-downloaded-filename>.deb
sudo apt install /tmp/<slack-downloaded-filename>.deb
```

### Visual Studio Code

Download the stable Debian/Ubuntu package from the [official VS Code Linux page](https://code.visualstudio.com/docs/setup/linux), then stage and install it (substitute the actual downloaded filename):

```bash
sudo install -m 0644 ~/Downloads/<code-downloaded-filename>.deb \
  /tmp/<code-downloaded-filename>.deb
sudo apt install /tmp/<code-downloaded-filename>.deb
```

### Bitwarden

Download Bitwarden Desktop from [Bitwarden's official downloads page](https://bitwarden.com/download/). Choose the Linux package offered for Ubuntu and follow the corresponding official instructions for that package format. If the page offers a `.deb`, stage and install it (substitute the actual downloaded filename):

```bash
sudo install -m 0644 ~/Downloads/<bitwarden-downloaded-filename>.deb \
  /tmp/<bitwarden-downloaded-filename>.deb
sudo apt install /tmp/<bitwarden-downloaded-filename>.deb
```

### Devolutions Remote Desktop Manager

Download the Linux version from the [Devolutions Remote Desktop Manager download page](https://devolutions.net/remote-desktop-manager/download/). Choose the Ubuntu/Debian `.deb` package, then stage and install the exact downloaded filename:

```bash
sudo install -m 0644 ~/Downloads/<rdm-downloaded-filename>.deb \
  /tmp/<rdm-downloaded-filename>.deb
sudo apt install /tmp/<rdm-downloaded-filename>.deb
```

Devolutions documents Linux updates as manual: download and install each newer `.deb` from its official site.

### FortiClient VPN

1. Confirm with your organization that its VPN configuration and authentication method are supported by FortiClient for Linux and Ubuntu 26.10.
2. Download the **FortiClient VPN-only** Linux package from [Fortinet Product Downloads](https://www.fortinet.com/support/product-downloads). Select the Linux/Ubuntu package that Fortinet currently supports. If 26.10 is not listed, ask your IT administrator before installing another release's package.
3. Stage and install the downloaded Ubuntu `.deb` (substitute the actual downloaded filename):

   ```bash
   sudo install -m 0644 ~/Downloads/<forticlient-downloaded-filename>.deb \
     /tmp/<forticlient-downloaded-filename>.deb
   sudo apt install /tmp/<forticlient-downloaded-filename>.deb
   ```

4. Launch FortiClient VPN from the app grid and enter the VPN gateway and sign-in details provided by your organization. Do not store corporate passwords in scripts or shell history.

## 7. First-run setup and verification

- Launch Chrome, Slack, VS Code, Bitwarden, Remote Desktop Manager, FortiClient VPN, and Tilix from the app grid. Sign in only to accounts you control or are authorized to use.
- In VS Code, install only the extensions needed for your work and sign in to GitHub/Microsoft if desired.
- Set your Git identity (use the name and email associated with your commits):

  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "you@example.com"
  git config --global init.defaultBranch main
  git config --global --list
  ```

- Verify Docker and database clients:

  ```bash
  sudo docker run hello-world
  mariadb --version
  psql --version
  ```

- Open **Software Updater** regularly, or run:

  ```bash
  sudo apt update
  sudo apt upgrade
  ```

## Official references

- [Ubuntu 26.10 release downloads and checksums](https://releases.ubuntu.com/26.10/)
- [Ubuntu Desktop installation tutorial](https://ubuntu.com/tutorials/install-ubuntu-desktop)
- [Dell Support](https://www.dell.com/support/home/)
- [Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Google Chrome](https://www.google.com/chrome/)
- [Slack for Linux](https://slack.com/downloads/linux)
- [VS Code on Linux](https://code.visualstudio.com/docs/setup/linux)
- [Bitwarden downloads](https://bitwarden.com/download/)
- [Devolutions Remote Desktop Manager downloads](https://devolutions.net/remote-desktop-manager/download/)
- [Devolutions RDM installation documentation](https://docs.devolutions.net/rdm/getting-started/installation/)
- [Fortinet Product Downloads](https://www.fortinet.com/support/product-downloads)
- [Ubuntu package search](https://packages.ubuntu.com/)
