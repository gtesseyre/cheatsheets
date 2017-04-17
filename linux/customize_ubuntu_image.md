###Get Ubuntu cloud image 
```
wget http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
```

###Install libguestfs-tools
```
apt-get install libguestfs-tools
```

###Mount the image and the folders
```
guestmount -a xenial-server-cloudimg-amd64-disk1.img -m /dev/sda1 /mnt

cd /mnt

mount -t proc proc proc/
mount -t sysfs sys sys/
mount -o bind /dev dev/
```

###Create a chroot and add what you want to install 
```
chroot .
apt-get install <PUT_YOUR_PACKAGES_HERE>
```
###Edit what you need - Example : Enabling root SSH login and changing root Login/Password  
```
openssl passwd -1
#Replace (*) in /etc/shadow for root by the value generated 
#edit /etc/ssh/sshd_config
```

###Exit chroot and unmount volumes 
```
exit
umount sys
umount proc
umount dev
cd ..
umount /mnt
```

###Create image in glance 
```
openstack image create --disk-format qcow2 --container-format bare --file /root/xenial-server-cloudimg-amd64-disk1.img --public xenial-ubuntu-server
```

