#!/bin/bash
source /etc/profile

# fill all free hdd space with zeros
dd if=/dev/zero of="$chroot/boot/EMPTY" bs=1M
rm "$chroot/boot/EMPTY"

dd if=/dev/zero of="$chroot/EMPTY" bs=1M
rm "$chroot/EMPTY"

# fill all swap space with zeros and recreate swap
swapoff ${disk1}3
shred -n 0 -z ${disk1}3
mkswap ${disk1}3
exit
