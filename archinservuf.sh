```bash
#!/bin/bash
# Arch Linux Minimal Home Server Installer
# Target: ThinkPad T480 / UEFI
# WARNING: This script will partition and format the selected disk.

set -e

if [[ $EUID -ne 0 ]]; then
    echo "Run this script as root."
    exit 1
fi

clear
echo "=========================================="
echo "     Arch Linux Home Server Installer"
echo "=========================================="
echo

# --------------------------------------------------
# Initial setup
# --------------------------------------------------

loadkeys us
timedatectl set-ntp true

sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 15/' /etc/pacman.conf

echo
echo "Available disks:"
lsblk -o NAME,SIZE,TYPE,MODEL
echo

read -rp "Enter installation disk (example: /dev/nvme0n1): " DRIVE

if [[ ! -b "$DRIVE" ]]; then
    echo "ERROR: $DRIVE is not a valid block device."
    exit 1
fi

echo
echo "WARNING: ALL DATA ON $DRIVE WILL BE DESTROYED."
read -rp "Type YES to continue: " CONFIRM

if [[ "$CONFIRM" != "YES" ]]; then
    echo "Installation cancelled."
    exit 1
fi

# --------------------------------------------------
# Partition disk
# --------------------------------------------------

echo
echo "Partitioning $DRIVE..."
echo

# EFI + root
parted -s "$DRIVE" mklabel gpt
parted -s "$DRIVE" mkpart ESP fat32 1MiB 513MiB
parted -s "$DRIVE" set 1 esp on
parted -s "$DRIVE" mkpart primary ext4 513MiB 100%

# Determine partition names
if [[ "$DRIVE" == *nvme* || "$DRIVE" == *mmcblk* ]]; then
    EFI="${DRIVE}p1"
    ROOT="${DRIVE}p2"
else
    EFI="${DRIVE}1"
    ROOT="${DRIVE}2"
fi

echo
echo "EFI partition:  $EFI"
echo "Root partition: $ROOT"
echo

# --------------------------------------------------
# Format
# --------------------------------------------------

mkfs.fat -F32 "$EFI"
mkfs.ext4 -F "$ROOT"

# --------------------------------------------------
# Mount
# --------------------------------------------------

mount "$ROOT" /mnt

mkdir -p /mnt/boot
mount "$EFI" /mnt/boot

# --------------------------------------------------
# Update package database
# --------------------------------------------------

pacman -Sy --noconfirm archlinux-keyring

# --------------------------------------------------
# Install base system
# --------------------------------------------------

pacstrap -K /mnt \
    base \
    base-devel \
    linux \
    linux-firmware \
    networkmanager \
    openssh \
    sudo \
    git \
    vim \
    man-db \
    man-pages \
    bash-completion \
    curl \
    wget \
    rsync \
    htop \
    tmux \
    unzip

# --------------------------------------------------
# Generate fstab
# --------------------------------------------------

genfstab -U /mnt >> /mnt/etc/fstab

# --------------------------------------------------
# Copy second stage
# --------------------------------------------------

cp "$0" /mnt/root/server_install.sh

chmod +x /mnt/root/server_install.sh

arch-chroot /mnt /root/server_install.sh --stage2

echo
echo "=========================================="
echo "Installation complete."
echo "=========================================="
echo
echo "Unmounting filesystem..."

umount -R /mnt

echo
echo "You can now reboot:"
echo
echo "    reboot"
echo
echo "Remove the Arch installation USB after reboot."
```

Create the second stage in the **same file** below this marker:

```bash
# ==================================================
# STAGE 2
# ==================================================

if [[ "$1" == "--stage2" ]]; then

    set -e

    echo
    echo "=========================================="
    echo " Configuring installed Arch system"
    echo "=========================================="
    echo

    # --------------------------------------------------
    # Timezone
    # --------------------------------------------------

    ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
    hwclock --systohc

    # --------------------------------------------------
    # Locale
    # --------------------------------------------------

    sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen

    locale-gen

    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    echo "KEYMAP=us" > /etc/vconsole.conf

    # --------------------------------------------------
    # Hostname
    # --------------------------------------------------

    echo
    read -rp "Enter hostname: " HOSTNAME

    echo "$HOSTNAME" > /etc/hostname

    cat > /etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${HOSTNAME}.localdomain ${HOSTNAME}
EOF

    # --------------------------------------------------
    # Initramfs
    # --------------------------------------------------

    mkinitcpio -P

    # --------------------------------------------------
    # Bootloader
    # --------------------------------------------------

    pacman -S --noconfirm grub efibootmgr

    grub-install \
        --target=x86_64-efi \
        --efi-directory=/boot \
        --bootloader-id=GRUB

    grub-mkconfig -o /boot/grub/grub.cfg

    # --------------------------------------------------
    # Root password
    # --------------------------------------------------

    echo
    echo "Set root password:"
    passwd

    # --------------------------------------------------
    # Create server user
    # --------------------------------------------------

    echo
    read -rp "Enter your username: " USERNAME

    useradd -m -G wheel "$USERNAME"

    echo
    echo "Set password for $USERNAME:"
    passwd "$USERNAME"

    # --------------------------------------------------
    # Sudo
    # --------------------------------------------------

    mkdir -p /etc/sudoers.d

    cat > /etc/sudoers.d/10-wheel <<EOF
%wheel ALL=(ALL:ALL) ALL
EOF

    chmod 440 /etc/sudoers.d/10-wheel

    # Validate sudo configuration
    visudo -cf /etc/sudoers

    # --------------------------------------------------
    # Enable networking
    # --------------------------------------------------

    systemctl enable NetworkManager

    # --------------------------------------------------
    # SSH configuration
    # --------------------------------------------------

    mkdir -p /etc/ssh/sshd_config.d

    cat > /etc/ssh/sshd_config.d/10-server.conf <<EOF
PermitRootLogin no
PasswordAuthentication yes
KbdInteractiveAuthentication no
PubkeyAuthentication yes
X11Forwarding no
EOF

    systemctl enable sshd

    # --------------------------------------------------
    # Firewall
    # --------------------------------------------------

    pacman -S --noconfirm nftables

    cat > /etc/nftables.conf <<EOF
#!/usr/sbin/nft -f

flush ruleset

table inet filter {

    chain input {
        type filter hook input priority 0;
        policy drop;

        # Loopback
        iif "lo" accept

        # Existing connections
        ct state established,related accept

        # Invalid packets
        ct state invalid drop

        # ICMP
        ip protocol icmp accept
        ip6 nexthdr icmpv6 accept

        # SSH
        tcp dport 22 accept
    }

    chain forward {
        type filter hook forward priority 0;
        policy drop;
    }

    chain output {
        type filter hook output priority 0;
        policy accept;
    }
}
EOF

    systemctl enable nftables

    # --------------------------------------------------
    # Server tools
    # --------------------------------------------------

    pacman -S --noconfirm \
        smartmontools \
        nvme-cli \
        lm_sensors \
        iotop \
        ncdu \
        tree \
        jq

    # --------------------------------------------------
    # Enable useful services
    # --------------------------------------------------

    systemctl enable fstrim.timer

    # --------------------------------------------------
    # Final information
    # --------------------------------------------------

    echo
    echo "=========================================="
    echo " Arch server installation finished"
    echo "=========================================="
    echo
    echo "Hostname: $HOSTNAME"
    echo "User:     $USERNAME"
    echo
    echo "Installed:"
    echo "  - Arch Linux"
    echo "  - NetworkManager"
    echo "  - OpenSSH"
    echo "  - nftables"
    echo "  - GRUB UEFI"
    echo "  - Server utilities"
    echo
    echo "After reboot:"
    echo
    echo "  1. Connect to the network"
    echo "  2. Find the server IP with:"
    echo "       ip addr"
    echo
    echo "  3. From another machine:"
    echo "       ssh $USERNAME@SERVER_IP"
    echo
    echo "IMPORTANT:"
    echo "SSH password authentication is currently enabled."
    echo "After confirming SSH key login works, disable it."
    echo
    echo "Installation complete."
    echo

    exit 0
fi
```
