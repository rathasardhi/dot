```bash
#!/bin/bash
#
# Arch Linux Minimal Home Server Installer
# Legacy BIOS ONLY
#
# WARNING:
# This script will ERASE the selected disk.
#

set -e

# ==================================================
# STAGE 1
# ==================================================

if [[ "$1" != "--stage2" ]]; then

    if [[ $EUID -ne 0 ]]; then
        echo "Run this script as root."
        exit 1
    fi

    clear

    echo "=========================================="
    echo "   Arch Linux Home Server Installer"
    echo "           LEGACY BIOS ONLY"
    echo "=========================================="
    echo

    # --------------------------------------------------
    # Check that we are NOT booted in UEFI mode
    # --------------------------------------------------

    if [[ -d /sys/firmware/efi ]]; then
        echo "ERROR: Arch ISO is currently booted in UEFI mode."
        echo
        echo "Boot the Arch USB in LEGACY/CSM mode and run"
        echo "this installer again."
        exit 1
    fi

    echo "Legacy BIOS boot detected."
    echo

    # --------------------------------------------------
    # Basic setup
    # --------------------------------------------------

    loadkeys us
    timedatectl set-ntp true

    sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 15/' /etc/pacman.conf

    # --------------------------------------------------
    # Show disks
    # --------------------------------------------------

    echo "Available disks:"
    echo

    lsblk -o NAME,SIZE,TYPE,MODEL

    echo

    read -rp "Enter installation disk (example: /dev/sda): " DRIVE

    if [[ ! -b "$DRIVE" ]]; then
        echo "ERROR: $DRIVE is not a valid block device."
        exit 1
    fi

    echo
    echo "Selected disk:"
    lsblk "$DRIVE"
    echo

    echo "=========================================="
    echo "WARNING!"
    echo "ALL DATA ON $DRIVE WILL BE DESTROYED!"
    echo "=========================================="
    echo

    read -rp "Type YES to continue: " CONFIRM

    if [[ "$CONFIRM" != "YES" ]]; then
        echo "Installation cancelled."
        exit 1
    fi

    # --------------------------------------------------
    # Partition disk
    # --------------------------------------------------

    echo
    echo "Creating MBR partition table..."

    wipefs -af "$DRIVE"

    parted -s "$DRIVE" mklabel msdos

    # One root partition
    parted -s "$DRIVE" mkpart primary ext4 1MiB 100%

    # Mark bootable
    parted -s "$DRIVE" set 1 boot on

    # Determine partition name
    if [[ "$DRIVE" == *nvme* || "$DRIVE" == *mmcblk* ]]; then
        ROOT="${DRIVE}p1"
    else
        ROOT="${DRIVE}1"
    fi

    echo
    echo "Root partition: $ROOT"
    echo

    # --------------------------------------------------
    # Format root
    # --------------------------------------------------

    mkfs.ext4 -F "$ROOT"

    # --------------------------------------------------
    # Mount
    # --------------------------------------------------

    mount "$ROOT" /mnt

    # --------------------------------------------------
    # Install Arch
    # --------------------------------------------------

    echo
    echo "Installing Arch Linux..."
    echo

    pacman -Sy --noconfirm archlinux-keyring

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
    # Copy installer to new system
    # --------------------------------------------------

    cp "$0" /mnt/root/server_install.sh

    chmod +x /mnt/root/server_install.sh

    # --------------------------------------------------
    # Stage 2
    # --------------------------------------------------

    arch-chroot /mnt \
        /root/server_install.sh \
        --stage2 \
        "$DRIVE"

    # --------------------------------------------------
    # Finish
    # --------------------------------------------------

    echo
    echo "=========================================="
    echo " Installation finished"
    echo "=========================================="
    echo

    umount -R /mnt

    echo
    echo "You can now reboot:"
    echo
    echo "    reboot"
    echo
    echo "Remove the Arch USB after reboot."

    exit 0
fi


# ==================================================
# STAGE 2
# ==================================================

if [[ "$1" == "--stage2" ]]; then

    set -e

    DRIVE="$2"

    echo
    echo "=========================================="
    echo " Configuring Arch Home Server"
    echo " Legacy BIOS"
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
    # Install GRUB for Legacy BIOS
    # --------------------------------------------------

    echo
    echo "Installing GRUB for Legacy BIOS..."
    echo

    pacman -S --noconfirm grub

    grub-install \
        --target=i386-pc \
        "$DRIVE"

    grub-mkconfig -o /boot/grub/grub.cfg

    # --------------------------------------------------
    # Root password
    # --------------------------------------------------

    echo
    echo "Set root password:"
    passwd

    # --------------------------------------------------
    # Create normal user
    # --------------------------------------------------

    echo
    read -rp "Enter username: " USERNAME

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

    visudo -cf /etc/sudoers

    # --------------------------------------------------
    # NetworkManager
    # --------------------------------------------------

    systemctl enable NetworkManager

    # --------------------------------------------------
    # SSH
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

        # Established connections
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
    # Server utilities
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
    # SSD TRIM
    # --------------------------------------------------

    systemctl enable fstrim.timer

    # --------------------------------------------------
    # Final message
    # --------------------------------------------------

    echo
    echo "=========================================="
    echo "       ARCH SERVER READY"
    echo "=========================================="
    echo
    echo "Hostname : $HOSTNAME"
    echo "User     : $USERNAME"
    echo "Boot     : Legacy BIOS"
    echo
    echo "Installed:"
    echo "  Arch Linux"
    echo "  Legacy GRUB"
    echo "  NetworkManager"
    echo "  OpenSSH"
    echo "  nftables"
    echo "  Server utilities"
    echo
    echo "After reboot:"
    echo
    echo "    ip addr"
    echo
    echo "Then connect from another computer:"
    echo
    echo "    ssh $USERNAME@SERVER_IP"
    echo
    echo "IMPORTANT:"
    echo "SSH password authentication is enabled initially."
    echo "After configuring SSH keys, disable password login."
    echo
    echo "Installation complete."

    exit 0
fi
```
