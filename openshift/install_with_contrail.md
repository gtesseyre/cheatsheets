[This install was done on Centos 7.3 using Contrail 4.0. 1 Master - 2 Slaves topology]

### 1. Setup passwordless SSH access - On the master
```
ssh-keygen -t rsa
ssh <user>@<host-ip> mkdir -p .ssh
ssh <user>@<host-ip> chmod 700 .ssh
cat /root/.ssh/id_rsa.pub | ssh <user>@<host-ip> 'cat >> .ssh/authorized_keys'
```

### 2. Install EPEL Repo - All nodes 
```
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel*rpm && yum update -y 
```

### 3. Install kernel and other packages  - All nodes 
```
yum install kernel-devel kernel-headers git vim nfs-utils socat -y
reboot
```
### 4. Add hostnames in /etc/hosts or make sure DNS resolution is happening in the cluster for all nodes - All nodes 

### 5. Install Ansible and clone the Openshift repo - On the master
```
yum install python2-pip openssl-devel python-devel gcc python-cffi -y
pip install ansible==2.2.0
git clone https://github.com/openshift/openshift-ansible
cd openshift-ansible/
```

### 6. Create a pre-requisite file 
```
cat <<EOF> inventory/byo/origin-prerequisites.yml
---
- hosts: OSEv3
  tasks:
  - name: Install the following base packages
    yum: name="{{ item }}" state=present
    with_items:
      - wget
      - net-tools
      - bind-utils
      - iptables-services
      - bridge-utils
      - bash-completion
      - python-pip

  - name: Install ansible and additional packages
    yum: name="{{ item }}" state=present enablerepo=epel
    with_items:
      - pyOpenSSL

  - name: Install Docker
    yum: name=docker state=present

  - name: Enable Docker Service
    service: name=docker enabled=yes

  - name: Start Docker Service
    service: name=docker state=started
EOF
```

### 7. Create a host file
```
cat <<EOF> inventory/byo/hosts.origin
# Create an OSEv3 group that contains the masters and nodes groups
[OSEv3:children]
masters
nodes
etcd

# Set variables common for all OSEv3 hosts
[OSEv3:vars]
ansible_ssh_user=root
ansible_become=yes
debug_level=2
deployment_type=origin
openshift_release=v1.5
openshift_install_examples=true
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]
osm_cluster_network_cidr=10.128.0.0/14
openshift_portal_net=172.30.0.0/16
openshift_use_dnsmasq=False

[masters]
100.64.16.3 openshift_hostname=openshift-master 

[etcd]
100.64.16.3 openshift_hostname=openshift-master 

[nodes]
100.64.16.4 openshift_hostname=openshift-slave-1 
100.64.16.5 openshift_hostname=openshift-slave-2 
EOF
```

### 8. Run the Ansible playbooks to install the prerequisites packages  
```
ansible-playbook -i inventory/byo/hosts.origin inventory/byo/origin-prerequisites.yml
```

### 9. Run the Ansible playbooks to install Openshift - At that point Openshift should be installed :-) !
```
ansible-playbook -i inventory/byo/hosts.origin playbooks/byo/openshift_facts.yml
ansible-playbook -i inventory/byo/hosts.origin playbooks/byo/config.yml
```

### 10. Clone Contrail Ansible Repo 
```
git clone https://github.com/Juniper/contrail-ansible
cd contrail-ansible/playbooks
```

### 11. Edit hosts and group vars files  
```
cat <<EOF> inventory/my-inventory/hosts
[contrail-repo]
100.64.16.3

[contrail-controllers]
100.64.16.3

[contrail-analyticsdb]
100.64.16.3

[contrail-analytics]
100.64.16.3

[contrail-kubernetes]
100.64.16.3

[contrail-compute]
100.64.16.4
100.64.16.5
EOF
```
```
cat <<EOF> inventory/my-inventory/group_vars/all.yml
docker_registry: 10.84.34.155:5000
docker_registry_insecure: True
docker_install_method: package
ansible_user: root
ansible_become: false
contrail_compute_mode: container
os_release: redhat7
contrail_version: 4.0.0.0-3057
cloud_orchestrator: openshift
vrouter_physical_interface: eno1
EOF
```

### 12. Run Ansible playbook to install Contrail 
```
ansible-playbook -i inventory/my-inventory site.yml
```
