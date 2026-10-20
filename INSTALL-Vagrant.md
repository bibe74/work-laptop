# Vagrant with libvirt on Debian

This guide installs Vagrant and its libvirt provider on a Debian-powered Dell
XPS 13, then creates an Ubuntu 26.04 LTS (Resolute) virtual machine. The commands
assume a 64-bit Intel or AMD XPS 13 and a Debian release that provides the
listed packages. Package versions and box images change over time; consult the
linked project documentation if a package or command differs on your Debian
release.

## 1. Check hardware virtualization

Vagrant uses QEMU/KVM through libvirt. Confirm that the processor supports
hardware virtualization and that it is enabled in the laptop firmware:

```bash
lscpu | grep -E 'Architecture|Virtualization'
grep -E -c 'vmx|svm' /proc/cpuinfo
```

The first command should report `x86_64`; the second should return a number
greater than zero. If it returns zero, restart the XPS 13, enter Dell UEFI
setup, and enable Intel Virtualization Technology (VT-x) or AMD SVM, depending
on the processor. Keep the laptop connected to AC power while creating or
updating virtual machines.

## 2. Install Vagrant, QEMU/KVM, and libvirt

Update Debian and install Vagrant from the Debian package repository along
with the libvirt provider's build and runtime dependencies:

```bash
sudo apt update
sudo apt full-upgrade
sudo apt install \
  vagrant \
  qemu-system-x86 \
  libvirt-daemon-system \
  libvirt-clients \
  libvirt-dev \
  ebtables \
  libguestfs-tools \
  ruby-fog-libvirt \
  ruby-dev \
  build-essential \
  pkg-config \
  libxml2-dev \
  libxslt1-dev \
  zlib1g-dev
```

Check that Debian installed Vagrant and the KVM device:

```bash
vagrant --version
test -e /dev/kvm && echo "KVM device is available"
```

If `apt` cannot locate `vagrant` for your Debian release, check
`apt-cache policy vagrant` and use the installation instructions for that
release from the [official Vagrant installation page](https://developer.hashicorp.com/vagrant/install).
Prefer not to mix a standalone HashiCorp Vagrant install with Debian's Vagrant
or Ruby packages; the libvirt plugin builds Ruby bindings that need to match
the Ruby environment used by Vagrant.

## 3. Start libvirt and grant your user access

Enable the libvirt daemon and add your login to the `libvirt` and `kvm` groups:

```bash
sudo systemctl enable --now libvirtd
sudo usermod -aG libvirt,kvm "$USER"
```

Log out of Debian and log back in so the new group membership takes effect.
These groups grant permission to control local virtual machines; only add
trusted users.

Confirm that the system libvirt connection works:

```bash
id -nG
virsh -c qemu:///system list --all
```

The output of `id -nG` should include `libvirt` and `kvm`. If the libvirt
`default` network is present but inactive, start it and configure it to start
automatically:

```bash
virsh -c qemu:///system net-list --all
sudo virsh -c qemu:///system net-start default
sudo virsh -c qemu:///system net-autostart default
```

If `default` is already active, the final two commands are unnecessary. The
default NAT network gives guests outbound connectivity without placing them
directly on the laptop's physical network.

## 4. Install the Vagrant libvirt provider

Install the plugin as your regular user, not with `sudo`:

```bash
vagrant plugin install vagrant-libvirt
vagrant plugin list
```

The list should include `vagrant-libvirt`. If plugin installation fails while
building a native Ruby extension, confirm that the packages in step 2 are
installed, especially `libvirt-dev`, `ruby-dev`, `build-essential`,
`libxml2-dev`, `libxslt1-dev`, and `zlib1g-dev`, then retry the plugin
installation.

The provider can be selected explicitly for each project with
`--provider=libvirt`. To make it the default for this shell account, add this
line to `~/.profile`:

```bash
export VAGRANT_DEFAULT_PROVIDER=libvirt
```

Log out and back in after editing `~/.profile`, or load it in the current
shell with `source ~/.profile`.

## 5. Create an Ubuntu 26.04 LTS project

Create a directory for the VM and change into it:

```bash
mkdir -p ~/vagrant/ubuntu2604
cd ~/vagrant/ubuntu2604
```

Create a `Vagrantfile` in that directory with the following contents:

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

This configures two virtual CPUs and 4 GiB of memory. Adjust those values to
fit the XPS 13's available memory and the workload. The
`cloud-image/ubuntu-26.04` box is the Ubuntu 26.04 LTS (Resolute) cloud image.
Ubuntu 26.04.1 is a
point release of the 26.04 LTS series; Vagrant boxes are cloud images rather
than the point-release desktop installer ISO, so the guest reports Ubuntu
26.04 (`resolute`) and may include image updates published after 26.04.1.
Vagrant downloads a compatible provider image the first time it is used.

To download the box explicitly and confirm that a libvirt image is available:

```bash
vagrant box add cloud-image/ubuntu-26.04 --provider libvirt
vagrant box list
```

Start the VM, explicitly selecting libvirt:

```bash
vagrant up --provider=libvirt
```

On its first run, Vagrant downloads the box if it is not already cached,
creates the guest, and configures SSH access. Connect and verify the guest OS:

```bash
vagrant ssh
lsb_release -a
```

The guest should identify as Ubuntu 26.04 LTS (`resolute`). Check the version
and codename with `lsb_release -a` or `cat /etc/os-release`. Type `exit` to
leave the guest shell.

## 6. Manage the virtual machine

Run these commands from the directory containing the `Vagrantfile`:

```bash
vagrant status       # Show the VM state
vagrant ssh          # Open a shell in the guest
vagrant halt         # Shut down the guest
vagrant up           # Start it again
vagrant suspend      # Save its current state
vagrant resume       # Resume a suspended guest
```

To remove the VM and its local disk, run:

```bash
vagrant destroy
```

This destroys the guest and its data, but leaves the downloaded box in the
local Vagrant box cache. Add `-f` to `vagrant destroy` only if you intend to
skip its confirmation prompt.

## Troubleshooting

- **`/dev/kvm` is missing:** Check that the CPU supports virtualization, that
  VT-x/SVM is enabled in Dell UEFI setup, and that the `kvm` kernel module is
  available. Reboot after changing firmware settings.
- **Permission denied connecting to libvirt:** Confirm that the current login
  is in the `libvirt` and `kvm` groups, then fully log out and log back in.
  Check access with `virsh -c qemu:///system list --all`.
- **The `default` network is inactive:** Start it and enable autostart as
  described in step 3. If it does not exist, check the Debian
  `libvirt-daemon-system` package and its network configuration.
- **The provider is not available:** Run `vagrant plugin list` as the same
  user who runs Vagrant. Reinstall the plugin without `sudo` after installing
  the development dependencies.
- **No libvirt box image is available:** Check the box's current provider list
  on [Vagrant Cloud](https://portal.cloud.hashicorp.com/vagrant/discover/cloud-image/ubuntu-26.04).
  The box must publish an image for the `libvirt` provider.

## References

- [Vagrant installation](https://developer.hashicorp.com/vagrant/install)
- [vagrant-libvirt installation guide](https://vagrant-libvirt.github.io/vagrant-libvirt/installation.html)
- [Ubuntu 26.04.1 LTS release announcement](https://lists.ubuntu.com/archives/ubuntu-announce/2026-August/000326.html)
- [Ubuntu 26.04 Vagrant box](https://portal.cloud.hashicorp.com/vagrant/discover/cloud-image/ubuntu-26.04)
