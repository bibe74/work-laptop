# Debian on a Dell XPS 13

This guide installs a standard Debian system on a Dell XPS 13 using the
graphical expert installer, Cinnamon, the SSH server, and a disabled root
account. The user created during installation should be able to use `sudo`.
It then installs and configures the workstation software and Vagrant/libvirt
environment covered in [INSTALL-CachyOS.md](./INSTALL-CachyOS.md).

Use the latest stable Debian AMD64 installer. These instructions assume a
64-bit Intel or AMD XPS 13; the installer wording and package versions may
vary slightly between Debian releases.

## 1. Prepare the laptop and installer

1. Confirm the exact XPS 13 model and that it has an AMD64/x86-64 processor.
   Do not use an AMD64 installer for an ARM-based XPS model.
2. Back up your files and verify that the backup can be restored. If keeping
   Windows or dual-booting, save the BitLocker recovery key. **Erasing a disk
   removes Windows and all data on the selected disk.**
3. Connect AC power. Install available Dell BIOS/firmware updates and note
   any customized firmware settings.
4. Download the current stable **64-bit PC (amd64) netinst** image from the
   [official Debian download page](https://www.debian.org/download/). Verify
   its checksum or signature using the files and instructions linked there.
5. Write the ISO to an 8 GB or larger USB drive with a tool such as
   [Rufus](https://rufus.ie/). This erases the USB drive.
6. Keep Secure Boot enabled unless the official Debian documentation or
   support for the exact laptop model requires another configuration.

## 2. Install Debian with the requested options

1. Shut down the XPS 13, insert the USB drive, power on, and tap **F12** at
   the Dell logo. Choose the UEFI USB entry.
2. In the Debian installer boot menu, open **Advanced options** and choose
   **Graphical expert install** (or the equivalent graphical expert option
   offered by the downloaded installer).
3. Select your language, location, keyboard, network connection, hostname,
   and domain if applicable. Use a wired connection or Wi-Fi if available.
   Allow the installer to load firmware required by the laptop when prompted.
4. When setting up users, **leave the root password blank** and confirm the
   choice to disable the root account. Set the name, username, and password
   for your regular user. On a standard Debian installation, the first user
   is then given `sudo` access. Do not set a root password later.
5. Partition the disk according to your backup and installation plan. For a
   Debian-only installation, guided partitioning is appropriate after you
   have confirmed the target disk. For dual boot, stop if the installer
   cannot safely resize an encrypted Windows installation.
6. Select the Debian archive mirror and allow the installer to configure
   APT.
7. At **Software selection / tasksel**, choose:
   - **Debian desktop environment** with **Cinnamon** as the desktop. Make
     sure GNOME or another desktop is not selected if you want Cinnamon only.
   - **SSH server**.
   - **standard system utilities**.

   Leave unrelated server tasks unchecked. Continue the installation, install
   the boot loader when prompted, remove the USB drive when asked, and reboot.

After the first login, confirm that the root account is disabled and the
installed user can administer the machine:

```bash
sudo -v
id
getent group sudo
sudo passwd -S root
```

The root password status should indicate a locked account. The current user
should be listed in the `sudo` group. If `sudo` is unavailable, do not work
around the disabled root account by assigning it a password; use Debian's
official recovery instructions to correct the initial-user configuration.

Update the system and reboot before installing desktop applications:

```bash
sudo apt update
sudo apt full-upgrade
sudo reboot
```

## 3. Install repository development tools

Install Git, the MariaDB and PostgreSQL command-line clients, LaTeX, Tilix,
and the optional system-info and fortune tools:

```bash
sudo apt install \
  git mariadb-client postgresql-client \
  texlive-latex-base texlive-latex-recommended texlive-fonts-recommended \
  latexmk tilix fastfetch fortune-mod fortunes-bofh-excuses
```

The PostgreSQL client package tracks the default version supplied by the
Debian release. To use a different PostgreSQL major version, consult the
official PostgreSQL instructions for Debian.

Optional larger TeX Live components:

```bash
sudo apt install texlive-latex-extra texlive-xetex
```

`screenfetch` is an older, unmaintained utility. Check whether the current
Debian release still provides it before installing; `fastfetch` above is the
maintained alternative:

```bash
apt-cache search screenfetch
screenfetch
```

Check the installed tools:

```bash
git --version
mariadb --version
psql --version
pdflatex --version
latexmk --version
fastfetch
fortune bofh-excuses
```

If APT cannot locate an optional package, check
[Debian Packages](https://packages.debian.org/) for the installed Debian
codename. Do not install an unrelated old package from a third-party mirror.

## 4. Install Docker Engine

Use Docker's signed Debian repository so package updates can update the Docker
Engine. First install its prerequisites and add the official signing key:

```bash
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg \
  -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Add the repository for the Debian release installed on the laptop:

```bash
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
```

Update APT and install Docker Engine and its maintained CLI plugins:

```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin
sudo systemctl enable --now docker.service
sudo docker run hello-world
docker compose version
```

Use `sudo docker` initially. Adding your account to the `docker` group grants
root-equivalent control of the machine; only do this if you understand and
accept that risk:

```bash
sudo usermod -aG docker "$USER"
```

Log out and back in for the group change to take effect. Docker-published
container ports can bypass firewall rules; review Docker's
[firewall guidance](https://docs.docker.com/engine/network/packet-filtering-firewalls/)
before exposing services.

## 5. Install desktop applications

Prefer the vendor's official Linux download. If a Debian `.deb` is offered,
download the current 64-bit package and install it through APT. APT resolves
dependencies and configures any package source supplied by the vendor.

When APT cannot read a package from the user's Downloads directory, stage it
in `/tmp` first. Replace the placeholder with the exact downloaded filename:

```bash
sudo install -m 0644 ~/Downloads/<downloaded-file>.deb \
  /tmp/<downloaded-file>.deb
sudo apt install /tmp/<downloaded-file>.deb
```

### Google Chrome

Download the stable Linux 64-bit `.deb` from
[Google Chrome](https://www.google.com/chrome/) and install it. The package
normally configures Google's APT source for updates. For the standard AMD64
package, the filename is commonly
`google-chrome-stable_current_amd64.deb`.

### Slack

Download the Linux `.deb` from
[Slack for Linux](https://slack.com/downloads/linux), then install the exact
downloaded filename using the staging commands above.

### Visual Studio Code

Download the stable Debian/Ubuntu package from the
[official VS Code Linux page](https://code.visualstudio.com/docs/setup/linux),
then install it using the staging commands above.

### Bitwarden

Download Bitwarden Desktop from
[Bitwarden's official downloads](https://bitwarden.com/download/). Choose a
Linux package currently supported for Debian. If the site offers a `.deb`,
install it using the staging commands above; otherwise follow the vendor's
instructions for the offered format.

### Devolutions Remote Desktop Manager

Download the Linux Debian package from the
[Devolutions Remote Desktop Manager download page](https://devolutions.net/remote-desktop-manager/download/).
Install the `.deb` using the staging commands above. Devolutions documents
Linux updates as manual, so download and install newer releases from the
official site.

### FortiClient VPN

1. Confirm with your organization that its VPN gateway, authentication
   method, and Debian release are supported by FortiClient for Linux.
2. Download the **FortiClient VPN-only** Debian package from
   [Fortinet Product Downloads](https://www.fortinet.com/support/product-downloads).
   If the installed Debian release is not listed, ask IT before using a
   package for another distribution or release.
3. Install the downloaded `.deb` using the staging commands above.
4. Launch FortiClient VPN and enter the gateway and sign-in details provided
   by your organization. Do not store corporate passwords in scripts or
   shell history.

## 6. Configure SSH and Git

The installer should have installed the SSH server task. Confirm the service
is active and enabled:

```bash
systemctl status ssh.service
sudo systemctl enable --now ssh.service
```

The root account is disabled, and SSH should be used with the regular
installation user. Do not expose SSH directly to untrusted networks without
appropriate firewall and authentication controls. For remote access, prefer
SSH keys and follow Debian's OpenSSH guidance.

Set the Git identity associated with your commits:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global --list
```

Launch Chrome, Slack, VS Code, Bitwarden, Remote Desktop Manager, FortiClient
VPN, and Tilix. Sign in only to accounts you control or are authorized to use.
In VS Code, install only the extensions needed for your work.

Verify Docker, database clients, and LaTeX:

```bash
sudo docker run hello-world
docker compose version
mariadb --version
psql --version
pdflatex --version
latexmk --version
```

Keep Debian updated with:

```bash
sudo apt update
sudo apt upgrade
```

## 7. Install Vagrant with QEMU/KVM and libvirt

Confirm that hardware virtualization is supported and enabled in Dell UEFI:

```bash
lscpu | grep -E 'Architecture|Virtualization'
grep -E -c 'vmx|svm' /proc/cpuinfo
```

The architecture should be `x86_64` and the second command should return a
number greater than zero. If it returns zero, check the processor capability
and enable Intel VT-x or AMD SVM in UEFI if available.

Install Vagrant, QEMU/KVM, libvirt, and the libvirt provider's build
dependencies:

```bash
sudo apt install \
  vagrant qemu-system-x86 \
  libvirt-daemon-system libvirt-clients libvirt-dev \
  ebtables libguestfs-tools ruby-fog-libvirt ruby-dev \
  build-essential pkg-config libxml2-dev libxslt1-dev zlib1g-dev
```

Check Vagrant and KVM:

```bash
vagrant --version
test -e /dev/kvm && echo "KVM device is available"
```

If APT cannot locate `vagrant` for the installed release, check
`apt-cache policy vagrant` and follow the
[official Vagrant installation page](https://developer.hashicorp.com/vagrant/install).
Avoid mixing a standalone HashiCorp Vagrant installation with Debian's Ruby
packages; the `vagrant-libvirt` native bindings must work with the Ruby
environment used by Vagrant.

Enable libvirt and add your account to its management groups:

```bash
sudo systemctl enable --now libvirtd.service
sudo usermod -aG libvirt,kvm "$USER"
```

Membership in `libvirt` and `kvm` grants permission to manage local virtual
machines. Log out and back in for group membership to take effect. Verify
access and network state:

```bash
id -nG
virsh -c qemu:///system list --all
virsh -c qemu:///system net-list --all
```

If the `default` network exists but is inactive, start it and configure it
to start automatically:

```bash
sudo virsh -c qemu:///system net-start default
sudo virsh -c qemu:///system net-autostart default
```

Install the provider as your regular user, not with `sudo`:

```bash
vagrant plugin install vagrant-libvirt
vagrant plugin list
```

The plugin list should include `vagrant-libvirt`. If its native Ruby extension
fails to build, confirm the development packages above are installed and
retry as the regular user.

To make libvirt the default provider for this account, add this line to
`~/.profile`:

```bash
export VAGRANT_DEFAULT_PROVIDER=libvirt
```

Log out and back in after editing the file, or load it in the current shell:

```bash
source ~/.profile
```

### Create an Ubuntu 26.04 Vagrant guest

Create a project directory:

```bash
mkdir -p ~/vagrant/ubuntu2604
cd ~/vagrant/ubuntu2604
```

Save the following as `Vagrantfile` in that directory:

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "cloud-image/ubuntu-26.04"
  config.vm.hostname = "ubuntu2604"

  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = 2
    libvirt.memory = 4096
  end
end
```

This allocates two virtual CPUs and 4 GiB of memory. Adjust those values to
fit the laptop and workload. Confirm that the box currently publishes a
libvirt image, then download and start it:

```bash
vagrant box add cloud-image/ubuntu-26.04 --provider libvirt
vagrant box list
vagrant up --provider=libvirt
```

Connect to the guest and verify its OS:

```bash
vagrant ssh
lsb_release -a
```

Type `exit` to leave the guest. From the directory containing the
`Vagrantfile`, manage it with:

```bash
vagrant status
vagrant ssh
vagrant halt
vagrant up
vagrant suspend
vagrant resume
```

`vagrant destroy` removes the VM and its local disk, but leaves the downloaded
box in the local cache. Add `-f` only if you intend to skip the confirmation
prompt.

## Troubleshooting

- **The regular user cannot run `sudo`:** Confirm that the root password was
  left blank during installation and that the initial user is in the `sudo`
  group. Follow Debian's recovery documentation rather than enabling root.
- **Cinnamon or SSH is missing:** Re-run task selection using Debian's
  supported tools or install the matching Debian task/package after checking
  the release documentation.
- **Wi-Fi or laptop hardware is not working:** Check the Debian firmware and
  hardware support documentation for the exact XPS model before changing
  firmware settings.
- **A `.deb` package fails to install:** Confirm it supports the installed
  Debian release and architecture. Install local `.deb` files through APT,
  not by extracting them or using `dpkg` without resolving dependencies.
- **`/dev/kvm` is missing:** Check CPU virtualization support and UEFI settings,
  then check that the appropriate KVM kernel module is available.
- **Permission denied connecting to libvirt:** Confirm the account is in the
  `libvirt` and `kvm` groups, then fully log out and back in.
- **The `default` libvirt network is inactive:** Start it and enable autostart
  as described above. If it is missing, check the libvirt network setup.
- **The Vagrant provider is unavailable:** Run `vagrant plugin list` as the
  same user who runs Vagrant and install the plugin without `sudo`.
- **No libvirt box image is available:** Check the box's current provider
  list on [Vagrant Cloud](https://portal.cloud.hashicorp.com/vagrant/discover/cloud-image/ubuntu-26.04).

## References

- [Debian downloads](https://www.debian.org/download)
- [Debian installation guide](https://www.debian.org/releases/stable/amd64/)
- [Debian Installation Guide: expert mode](https://www.debian.org/releases/stable/amd64/ch06s03.en.html)
- [Debian tasksel documentation](https://wiki.debian.org/tasksel)
- [Debian sudo documentation](https://wiki.debian.org/sudo)
- [Debian OpenSSH documentation](https://wiki.debian.org/SSH)
- [Debian package search](https://packages.debian.org/)
- [Docker Engine on Debian](https://docs.docker.com/engine/install/debian/)
- [Docker firewall guidance](https://docs.docker.com/engine/network/packet-filtering-firewalls/)
- [Google Chrome](https://www.google.com/chrome/)
- [Slack for Linux](https://slack.com/downloads/linux)
- [VS Code on Linux](https://code.visualstudio.com/docs/setup/linux)
- [Bitwarden downloads](https://bitwarden.com/download/)
- [Devolutions Remote Desktop Manager downloads](https://devolutions.net/remote-desktop-manager/download/)
- [Devolutions RDM installation documentation](https://docs.devolutions.net/rdm/getting-started/installation/)
- [Fortinet Product Downloads](https://www.fortinet.com/support/product-downloads)
- [Vagrant installation](https://developer.hashicorp.com/vagrant/install)
- [vagrant-libvirt installation guide](https://vagrant-libvirt.github.io/vagrant-libvirt/installation.html)
- [Ubuntu 26.04 Vagrant box](https://portal.cloud.hashicorp.com/vagrant/discover/cloud-image/ubuntu-26.04)
