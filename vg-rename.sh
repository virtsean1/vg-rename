#!/bin/bash
#vg-rename.sh - 202004231942

echo="/usr/bin/echo"
vgscan="/usr/sbin/vgscan"
vgrename="/usr/sbin/vgrename"
vgchange="/usr/sbin/vgchange -ay"
lvchange="/usr/sbin/lvchange"
sed="/usr/bin/sed"
dracut="/usr/bin/dracut"

$vgscan
read -p "Current Volume Group Name: " cvgname
read -p "New Volume Group Name: " nvgname

$echo "$vgrename $cvgname $nvgname"
read -n 1 -p "Ok?  Any key to go!"
$vgrename $cvgname $nvgname

$vgchange
$lvchange /dev/$nvgname/swap --refresh
$lvchange /dev/$nvgname/home --refresh
$lvchange /dev/$nvgname/root --refresh
$echo

$sed -i 's/'"$cvgname"'/'"$nvgname"'/g' /boot/grub2/grub.cfg
$echo

$sed -i 's/'"$cvgname"'/'"$nvgname"'/g' /boot/grub2/grubenv
$echo

$sed -i 's/'"$cvgname"'/'"$nvgname"'/g' /etc/fstab
$echo

$dracut -f --regenerate-all
$echo

$echo "Done.  Time to reboot."
exit
