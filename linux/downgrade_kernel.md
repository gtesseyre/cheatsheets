### Download Kernel Packages 
```
apt-get install linux-image-3.19.0-33-generic linux-tools-3.19.0-33-generic linux-headers-3.19.0-33-generic linux-image-extra-3.19.0-33-generic
```

### Update GRUB
```
crudini --set --existing /etc/default/grub "" GRUB_DEFAULT '"Advanced options for Ubuntu>Ubuntu, with Linux 3.19.0-33-generic"'

update-grub
reboot
```

### Verify new kernel is in use
```
uname -a
```

