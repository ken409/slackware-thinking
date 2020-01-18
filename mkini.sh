#!/bin/sh

kernel_new=$(ls -1 /boot/vm*generic* | tail -n 1 | rev | cut -d- -f1 | rev)
kernel_old=$(grep generic /etc/lilo.conf | rev | cut -d- -f1 | rev)

sed -i.old -e "s/$kernel_old/$kernel_new/" /etc/lilo.conf

rm /boot/initrd.gz

mkinitrd  \
	-c \
	-k $kernel_new \
	-f ext4 \
	-m usb-storage:xhci-hcd:usbhid:hid_generic:mbcache:jbd2:ext4 \
	-r /dev/cryptvg/root \
	-C /dev/sda2 \
	-T /dev/sda2 \
	-h /dev/cryptvg/swap \
	-L \
	-K LABEL=20171223_01:/boot/alien.luks \
	-u \
	-o /initrd.gz 

cat /boot/intel-ucode.cpio /initrd.gz > /boot/initrd.gz

lilo -v
