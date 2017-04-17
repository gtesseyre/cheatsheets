fab uninstall_contrail:full=True

for i in $(dpkg -l | grep contrail  | awk '{print $2}') ;do apt-get -y --purge remove $i; done;apt-get -y autoremove
