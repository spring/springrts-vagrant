#!/bin/bash
source /etc/profile

# use grub2
cat <<DATAEOF > "$chroot/etc/portage/package.accept_keywords/grub"
sys-boot/grub:2
DATAEOF

cat <<DATAEOF > "$chroot/etc/portage/package.use/grub"
sys-boot/grub -fonts -themes
DATAEOF


# install grub
chroot "$chroot" emerge grub

# tweak timeout
chroot "$chroot" sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/g" /etc/default/grub

# load virtio drivers to allow kvm boot
chroot "$chroot" sed -i "s/#GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=doload=virtio_pci,virtio_blk/g" /etc/default/grub

# make the disk bootable
chroot "$chroot" /bin/bash <<DATAEOF
source /etc/profile && \
env-update && \
grep -v rootfs /proc/mounts > /etc/mtab && \
mkdir -p /boot/grub && \
grub-mkconfig -o /boot/grub/grub.cfg && \
grub-install --no-floppy ${disk1}
DATAEOF
