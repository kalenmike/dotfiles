# 1. Register it (Change the paths to match your actual folder/file)
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/my-cool-theme/my-cool-theme.plymouth 100

# 2. Select it
sudo update-alternatives --config default.plymouth

# 3. Update the boot image
sudo update-initramfs -u



sudo update-alternatives --set default.plymouth /usr/share/plymouth/themes/solar/solar.plymouth


sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/solar/solar.plymouth 100




cat /sys/module/nvidia_drm/parameters/modeset

lsinitramfs /boot/initrd.img-$(uname -r) | grep nvidia



sudo nano /etc/initramfs-tools/modules
nvidia
nvidia_modeset
nvidia_uvm
nvidia_drm

sudo nano /etc/modprobe.d/nvidia-kms.conf
options nvidia-drm modeset=1


/etc/modprobe.d/no-bluetooth.conf
blacklist btusb
blacklist bluetooth


dmesg | grep -i "timeout" or "waiting"


cat /etc/plymouth/plymouthd.conf
[Daemon]
Theme=spinner
ShowDelay=0
DeviceTimeout=8
