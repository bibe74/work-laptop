# CachyOS on a Dell XPS 13

This guide starts with a blank Dell XPS 13 and installs CachyOS, the Linux
development and desktop software from [INSTALL-Ubuntu.md](./INSTALL-Ubuntu.md),
and the Vagrant/libvirt setup from [INSTALL-Vagrant.md](./INSTALL-Vagrant.md).
It assumes a 64-bit Intel or AMD XPS 13. CachyOS is a rolling-release Arch
Linux distribution, so package names and vendor support can change; check the
linked official documentation if a package is unavailable.

## 1. Prepare the laptop and installer

1. Confirm the exact XPS 13 model and that it has an AMD64/x86-64 processor.
   CachyOS x86-64 images are not for ARM-based XPS models.
2. Back up your data and verify that you can restore it. If replacing Windows
   or dual-booting, save the BitLocker recovery key and understand that
   **erasing a disk deletes its contents**.
3. Connect AC power. Install available Dell BIOS/firmware updates and note any
   customized firmware settings.
4. Download the current x86-64 desktop ISO from the
   [CachyOS download page](https://cachyos.org/download/). Verify its checksum
   or signature using the instructions published with that ISO.
5. Write the image to an 8 GB or larger USB drive using the
   [CachyOS installation guide](https://wiki.cachyos.org/docs/installation/desktop/).
   Writing the image erases the USB drive.
6. Keep Secure Boot enabled unless CachyOS's current installation
   documentation or support for the exact laptop model requires another
   configuration. Do not change firmware security settings without
   understanding the consequences.

## 2. Install CachyOS

1. Shut down the XPS 13, insert the USB drive, power on, and tap **F12** at the
   Dell logo. Select the UEFI USB entry.
2. Start the live environment and test Wi-Fi, keyboard, touchpad, audio,
   brightness, camera, and suspend/resume before installing.
3. Launch the CachyOS installer. Select the appropriate keyboard, network,
   desktop, time zone, and user options.
4. At the disk screen, choose an erase/install option only after confirming
   the target disk and backup. For dual boot, use the installer's supported
   workflow; stop if Windows encryption or partitioning is unclear. If
   enabling disk encryption, keep recovery information somewhere other than
   this laptop.
5. Finish installation, remove the USB when prompted, and restart.

After the first login, connect to the network and fully update the rolling
system before installing applications:

```bash
sudo pacman -Syu
sudo reboot
```

Do not interrupt a system upgrade. On Arch-based systems, perform full
upgrades with `pacman -Syu` rather than refreshing package databases and
upgrading only selected packages.

## 3. Install repository software

Install Git, database command-line tools, LaTeX, Tilix, Docker, and the
optional system-info and fortune utilities:

```bash
sudo pacman -S --needed \
  git mariadb-clients postgresql \
  texlive-basic texlive-latex texlive-latexrecommended \
  texlive-fontsrecommended latexmk tilix \
  docker docker-compose docker-buildx \
  fastfetch fortune-mod
```

On Arch, `postgresql` provides `psql` as well as PostgreSQL server components.
For a client-only workstation, do not initialize a database cluster or enable
the PostgreSQL service.

The Ubuntu guide's optional larger TeX installation corresponds to these
packages:

```bash
sudo pacman -S --needed texlive-latexextra texlive-xetex
```

`screenfetch` is an older, unmaintained utility and might not be available in
the CachyOS/Arch repositories. `fastfetch` is installed above as the maintained
alternative. Search before installing an optional package:

```bash
pacman -Ss screenfetch
pacman -Ss bofh
```

BOFH fortune files may only be available as an AUR package. If you want them,
search the AUR for a maintained BOFH data package, review its build files, and
install it using the procedure in section 5. One package name used for this
data is `fortune-mod-bofh-excuses`. Then try:

```bash
fortune bofh-excuses
```

Check the installed tools:

```bash
git --version
mariadb --version
psql --version
pdflatex --version
latexmk --version
fastfetch
```

If `pacman` cannot find a named package, check the
[Arch Linux package search](https://archlinux.org/packages/) and the current
CachyOS documentation rather than installing an unrelated package archive.

## 4. Install Docker Engine

The `docker`, `docker-compose`, and `docker-buildx` packages above install the
engine and CLI plugins from the Arch-based repositories. Enable and start
Docker, then test it using `sudo`:

```bash
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

Some vendor Linux downloads are Debian/RPM packages, which are not directly
installable on CachyOS. Prefer a vendor-maintained Arch package when available,
or use a package from the Arch User Repository (AUR) after reviewing its build
instructions. AUR packages are user-submitted and are **not** reviewed or
supported by CachyOS or Arch Linux.

### Build AUR packages safely

The AUR does not require a helper. Install the required build tools (already
covered by `base-devel` if you install it below), obtain one package at a
time, inspect its `PKGBUILD` and any install scripts, then build it as your
regular user:

```bash
sudo pacman -S --needed base-devel git
mkdir -p ~/build/aur
cd ~/build/aur
git clone https://aur.archlinux.org/<package-name>.git
cd <package-name>
less PKGBUILD
makepkg -si
```

Replace `<package-name>` with the package's exact AUR name. Do not run
`makepkg` with `sudo`. Check the package page and review changes again before
updates; do not assume a package remains maintained or trustworthy.

### Google Chrome

Google does not publish a native Arch repository package. Install the
`google-chrome` AUR package using the procedure above. Its build downloads
Chrome from Google's official distribution source.

### Slack

Install the `slack-desktop` AUR package, after reviewing its current package
page and build files.

### Visual Studio Code

For Microsoft's branded stable build, install the `visual-studio-code-bin` AUR
package. The open-source `code` package is an alternative, but it is not the
same Microsoft-branded distribution and may not provide the same services or
extensions.

### Bitwarden

First check whether the current repositories provide the desktop package:

```bash
pacman -Si bitwarden
```

If available, install it with `sudo pacman -S bitwarden`. Otherwise, use the
Linux package format currently offered by
[Bitwarden's official downloads](https://bitwarden.com/download/) only if it
supports Arch/CachyOS, or check for a maintained AUR package and inspect it
before building.

### Devolutions Remote Desktop Manager

Install the `remote-desktop-manager` AUR package if it is still maintained
and compatible with the current CachyOS release. Review its current AUR
`PKGBUILD` and the vendor's
[Linux installation documentation](https://docs.devolutions.net/rdm/getting-started/installation/).
Devolutions also publishes Linux downloads on its
[official download page](https://devolutions.net/remote-desktop-manager/download/);
do not attempt to install a Debian `.deb` directly with `pacman`.

### FortiClient VPN

Confirm with your organization that FortiClient VPN for Linux supports its
gateway, authentication method, and current CachyOS base. If IT approves it,
check the current `forticlient-vpn` AUR package, review its build files and
compatibility notes, and install it using the AUR procedure above. Do not
substitute a package for another Linux distribution or save corporate
credentials in scripts or shell history. If this client is not supported,
ask IT for an approved VPN alternative.

## 6. Configure Git and verify applications

Set the identity associated with your commits:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global --list
```

Launch Chrome, Slack, VS Code, Bitwarden, Remote Desktop Manager, FortiClient
VPN, and Tilix. Sign in only to accounts you control or are authorized to use.
Install only the VS Code extensions you need.

Verify Docker and database/LaTeX tools:

```bash
sudo docker run hello-world
docker compose version
mariadb --version
psql --version
pdflatex --version
latexmk --version
```

Keep CachyOS updated using its supported updater or:

```bash
sudo pacman -Syu
```

## 7. Install Vagrant with QEMU/KVM and libvirt

This section follows [INSTALL-Vagrant.md](./INSTALL-Vagrant.md), adapted for
CachyOS. Confirm that hardware virtualization is enabled in Dell UEFI:

```bash
lscpu | grep -E 'Architecture|Virtualization'
grep -E -c 'vmx|svm' /proc/cpuinfo
```

The architecture should be `x86_64` and the second command should return a
number greater than zero. If it returns zero, check the processor capability
and enable Intel VT-x or AMD SVM in UEFI if available.

Install QEMU/KVM, libvirt, and Vagrant's build/runtime dependencies:

```bash
sudo pacman -S --needed \
  base-devel git ruby rubygems pkgconf \
  qemu-desktop libvirt dnsmasq ebtables libguestfs \
  libxml2 libxslt zlib
```

`vagrant` may not be available in the enabled CachyOS repositories. Check
first:

```bash
pacman -Si vagrant
```

If it is unavailable, install the current `vagrant` AUR package using the
review-and-build procedure in section 5. Do not mix unrelated Ruby or Vagrant
installations; the libvirt plugin's native bindings must work with the Ruby
environment used by Vagrant.

Enable libvirt and grant your account permission to use the system connection:

```bash
sudo systemctl enable --now libvirtd.service
sudo usermod -aG libvirt,kvm "$USER"
```

If the `libvirt` or `kvm` group is not present on the installed release, check
the current CachyOS/Arch libvirt instructions and use its configured
polkit-based access model instead of creating groups blindly. Log out and
back in after group changes. Membership in these groups grants access to
manage local virtual machines.

Verify libvirt access and the KVM device:

```bash
id -nG
test -e /dev/kvm && echo "KVM device is available"
virsh -c qemu:///system list --all
```

If a `default` libvirt network exists but is inactive, start it and enable
autostart:

```bash
virsh -c qemu:///system net-list --all
sudo virsh -c qemu:///system net-start default
sudo virsh -c qemu:///system net-autostart default
```

Install the Vagrant provider as your regular user, not with `sudo`:

```bash
vagrant plugin install vagrant-libvirt
vagrant plugin list
```

The plugin list should include `vagrant-libvirt`. If installation fails while
building native Ruby extensions, confirm the development dependencies above
are installed and that `vagrant` and Ruby are compatible.

To use libvirt by default for your account, add this line to `~/.profile`:

```bash
export VAGRANT_DEFAULT_PROVIDER=libvirt
```

Then log out and back in, or load the profile in the current shell:

```bash
source ~/.profile
```

### Create an Ubuntu 26.04 Vagrant guest

Create a project directory and its `Vagrantfile`:

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

This allocates two virtual CPUs and 4 GiB of memory; adjust it to fit the
laptop and workload. Check that the box currently publishes a libvirt image,
then download and start it:

```bash
vagrant box add cloud-image/ubuntu-26.04 --provider libvirt
vagrant box list
vagrant up --provider=libvirt
```

Connect to the guest and confirm its OS:

```bash
vagrant ssh
lsb_release -a
```

Type `exit` to leave the guest. From the Vagrant project directory, manage it
with:

```bash
vagrant status
vagrant ssh
vagrant halt
vagrant up
vagrant suspend
vagrant resume
```

`vagrant destroy` removes the VM and its local disk. It does not remove the
downloaded box. Only add `-f` if you intend to skip the confirmation prompt.

## Troubleshooting

- **Wi-Fi or laptop hardware is not working:** Check the CachyOS hardware
  support notes for the exact XPS model and its current kernel/firmware
  requirements before changing firmware settings.
- **A package cannot be found:** Update with `sudo pacman -Syu`, search the
  official repositories, and verify the current package name. Do not install
  random package archives.
- **An AUR package fails to build or appears abandoned:** Stop and inspect its
  current maintenance status and compatibility. Do not bypass build errors by
  installing an unrelated Debian/RPM package.
- **`/dev/kvm` is missing:** Check CPU virtualization support and UEFI settings,
  then check whether the `kvm_intel` or `kvm_amd` kernel module is available.
- **Permission denied connecting to libvirt:** Confirm the account's
  configured libvirt permissions and fully log out/in after group changes.
- **The `default` network is inactive:** Start it and enable autostart as
  described above. If it is missing, consult the current libvirt network
  setup documentation.
- **The Vagrant provider is unavailable:** Run `vagrant plugin list` as the
  same user who runs Vagrant; install the plugin without `sudo`.
- **No libvirt box image is available:** Check the box's current provider
  list on [Vagrant Cloud](https://portal.cloud.hashicorp.com/vagrant/discover/cloud-image/ubuntu-26.04).

## References

- [CachyOS downloads](https://cachyos.org/download/)
- [CachyOS installation guide](https://wiki.cachyos.org/installation/)
- [Arch Linux package search](https://archlinux.org/packages/)
- [Arch User Repository](https://aur.archlinux.org/)
- [Docker Engine installation documentation](https://docs.docker.com/engine/install/)
- [Docker firewall guidance](https://docs.docker.com/engine/network/packet-filtering-firewalls/)
- [Google Chrome](https://www.google.com/chrome/)
- [Slack for Linux](https://slack.com/downloads/linux)
- [Visual Studio Code on Linux](https://code.visualstudio.com/docs/setup/linux)
- [Bitwarden downloads](https://bitwarden.com/download/)
- [Devolutions Remote Desktop Manager downloads](https://devolutions.net/remote-desktop-manager/download/)
- [Devolutions RDM installation documentation](https://docs.devolutions.net/rdm/getting-started/installation/)
- [Fortinet Product Downloads](https://www.fortinet.com/support/product-downloads)
- [Vagrant installation](https://developer.hashicorp.com/vagrant/install)
- [vagrant-libvirt installation guide](https://vagrant-libvirt.github.io/vagrant-libvirt/installation.html)
- [Ubuntu 26.04 Vagrant box](https://portal.cloud.hashicorp.com/vagrant/discover/cloud-image/ubuntu-26.04)
