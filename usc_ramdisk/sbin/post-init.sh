#!/system/xbin/busybox sh

# Remount FileSys RW
busybox mount -t rootfs -o remount,rw rootfs

## Create the kernel data directory
if [ ! -d /data/.DroidRoidz ];
then
mkdir /data/.DroidRoidz
  chmod 777 /data/.DroidRoidz
fi

## Enable "post-init" ...
if [ -f /data/.DroidRoidz/post-init.log ];
then
  # BackUp old post-init log
  mv /data/.DroidRoidz/post-init.log /data/.DroidRoidz/post-init.log.BAK
fi

# Start logging
date >/data/.DroidRoidz/post-init.log
exec >>/data/.DroidRoidz/post-init.log 2>&1

## install Kernel related Apps etc
# /xbin/busybox sh /sbin/ext/install.sh
# echo "Running Post-Init Script"


## Testing: Check for ExFat SD Card
#
#SDTYPE=`blkid /dev/block/mmcblk1p1 | awk '{ print $3 }' | sed -e 's|TYPE=||g' -e 's|\"||g'`

#if [ ${SDTYPE} == "exfat" ];
#then
#echo "ExFat-Debug: SD-Card is type ExFAT"
#  echo "ExFat-Debug: trying to mount via fuse"
#  mount.exfat-fuse /dev/block/mmcblk1p1 /storage/extSdCard
#else
#echo "ExFat-Debug: SD-Card is type: ${SDTYPE}"
#fi

## frandom kernel module
if [ -f /system/lib/modules/frandom.ko ];
then
echo "FRANDOM: found frandom Kernelmodule, loading..."
  insmod /system/lib/modules/frandom.ko
else
echo "FRANDOM: frandom Kernelmodule not found, skipping..."
fi

#init.d
busybox run-parts /system/etc/init.d

# Remount FileSys RO
busybox mount -t rootfs -o remount,ro rootfs

echo "Post-init finished !!!!"

