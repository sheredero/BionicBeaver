#!/bin/bash
DATE=`date "+%Y%m%d-%Hh%M"`
VER=18.04.2
apt-get update -y && apt-get upgrade -y
clear
apt-get install wget unzip bsdtar genisoimage git -y
sleep 30
cd /root
wget cdimage.ubuntu.com/releases/"$VER"/release/ubuntu-"$VER"-server-amd64.iso
mkdir /root/ubuntu-"$VER"-amd64-preseed
mkdir /root/initrd-preseed
bsdtar -C ubuntu-"$VER"-amd64-preseed/ -xf  ubuntu-"$VER"-server-amd64.iso
mv debian-"$VER"-amd64-preseed/install.amd/initrd.gz initrd-preseed/
cd /root/initrd-preseed/
gunzip -c initrd.gz | cpio -id
rm /root/initrd-preseed/initrd.gz
cd /root
git clone https://github.com/sheredero/BionicBeaver;
cp /root/BionicBeaver/preseed.cfg /root/initrd-preseed/
chmod 755 /root/initrd-preseed/preseed.cfg
cd /root/initrd-preseed/
find . | cpio -H newc --create --verbose | gzip -9 > /root/ubuntu-"$VER"-amd64-preseed/install.amd/initrd.gz
cd /root/ubuntu-"$VER"-amd64-preseed/
### lrwxrwxrwx  1 root root 1 fevr.  8 14:46 debian -> .
unlink /root/ubuntu-"$VER"-amd64-preseed/ubuntu
genisoimage -o ../ubuntu-"$VER"-amd64-preseed"$DATE".iso -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/boot.cat .
ls -lh /root/ubuntu-"$VER"-amd64-preseed*.iso
