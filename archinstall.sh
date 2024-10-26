!# bin/bash
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
pacman --noconfirm -Sy archlinux-keyring
loadkeys us
timedatectl set-ntp true
lsblk
echo "Enter the drive: "
read drive
cfdisk $drive 
echo "Enter the root linux partition: "
read partition
mkfs.ext4 $partition 
mount $partition /mnt 
pacman -S reflector
pacstrap /mnt base base-devel linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab
sed '1,/^#part2$/d' `basename $0` > /mnt/arch_install2.sh
chmod +x /mnt/arch_install2.sh
arch-chroot /mnt ./arch_install2.sh
exit 

#part2
printf '\033c'
pacman -S --noconfirm sed
sed -i "s/^#ParallelDownloads = 5$/ParallelDownloads = 15/" /etc/pacman.conf
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "Hostname: "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1       localhost" >> /etc/hosts
echo "::1             localhost" >> /etc/hosts
echo "127.0.1.1       $hostname.localdomain $hostname" >> /etc/hosts
mkinitcpio -P
passwd
pacman -S grub --noconfirm
echo "Enter boot partition grub: " 
read bootpartition
grub-install $bootpartition
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S --noconfirm xorg-server xorg-xinit xorg-xkill xorg-xsetroot xorg-xbacklight xorg-xprop \
     noto-fonts noto-fonts-emoji noto-fonts-cjk ttf-jetbrains-mono ttf-joypixels ttf-font-awesome \
     sxiv mpv zathura zathura-pdf-mupdf ffmpeg imagemagick  \
     fzf man-db feh python-pywal unclutter xclip maim \
     zip unzip unrar p7zip xdotool papirus-icon-theme brightnessctl  \
     dosfstools ntfs-3g git sxhkd  pipewire pipewire-pulse \
     emacs-nox arc-gtk-theme rsync qutebrowser dash \
     xcompmgr libnotify dunst slock jq aria2 cowsay \
     connman  rsync pamixer  \
      xdg-user-dirs libconfig \
     bluez bluez-utils fish  vim ttf-hack lxappearance bash-completion firefox urxvt-perls rxvt-unicode rx_tools  polybar redshift deja-dup kitty dmenu sxhkd bspwm  



useradd -m ak
passwd ak
usermod -aG wheel,audio,video,storage ak
EDITOR=vim visudo
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "Pre-Installation Finish Reboot now"
ai3_path=/home/$username/arch_install3.sh
sed '1,/^#part3$/d' arch_install2.sh > $ai3_path
chown $username:$username $ai3_path
chmod +x $ai3_path
su -c $ai3_path -s /bin/sh $username

pacman -S  networkmanager 
systemctl enable NetworkManager.service
cd /home/ak
mkdir .scripts
cd .scripts
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd /home/ak/.scripts
git clone https://github.com/rathasardhi/dot.git
cd dot/
cp .bashrc .rtorrent.rc .vimrc .Xdefaults .zshrc /home/ak
exit




