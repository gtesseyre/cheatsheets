### 0. Setup details 
```
[root@b7s40 ~]# cat /etc/redhat-release
CentOS Linux release 7.3.1611 (Core)
[root@b7s40 ~]# uname -a
Linux b7s40 3.10.0-514.el7.x86_64 #1 SMP Tue Nov 22 16:42:41 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
```

### 1. Install Ansible on your laptop or another client machine but not on the master node
On a MacOS laptop
```
pip install ansible==2.2.0.0
```
On a CentOS machine
```
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel*rpm && yum update -y
yum install ansible python-pip vim git
```

### 2. Enabled password less SSH for all nodes
```
ssh-keygen -t rsa
ssh <user>@<host-ip> mkdir -p .ssh
ssh <user>@<host-ip> chmod 700 .ssh
cat /root/.ssh/id_rsa.pub | ssh <user>@<host-ip> 'cat >> .ssh/authorized_keys'
```
### 3. Update /etc/hosts with all hostnames from the cluster or make sure DNS resolution is happening

### 4. Install Contrail using Ansible provisionning (https://github.com/Juniper/contrail-ansible)
#### 4.1 Get contrail-ansible
```
git clone -b R4.0 https://github.com/Juniper/contrail-ansible.git
cd contrail-ansible/playbooks
```
#### 4.2 Edit hosts and vars files
```
cat <<EOF> inventory/my-inventory/hosts
# Enable contrail-repo when required - this will start a contrail apt or yum repo container on specified node
# This repo will be used by other nodes on installing any packages in the node
# setting up contrail-cni need this repo enabled
# NOTE: Repo is required only for mesos and nested mode kubernetes
[contrail-repo]
10.84.29.40
 
[contrail-controllers]
10.84.29.40
 
[contrail-analyticsdb]
10.84.29.40
 
[contrail-analytics]
10.84.29.40
 
[contrail-kubernetes]
10.84.29.40
 
[contrail-compute]
10.84.29.41
10.84.29.42
 
##
# Only enable if you setup with openstack (when cloud_orchestrator is openstack)
##
;[openstack-controllers]
;192.168.0.23
EOF

cat <<EOF> inventory/my-inventory/group_vars/all.yml
###################################################
# Docker configurations
##
# docker registry
docker_registry: 10.84.34.155:5000
docker_registry_insecure: True
 
# install docker from package rather than installer from get.docker.com which is default method
docker_install_method: package
 
###################################################
# Ansible specific vars
##
 
# ansible connection details
ansible_user: root
ansible_become: true
# ansible_ssh_private_key_file: ~/.ssh/id_rsa
 
###################################################
# Common settings for contrail
##
 
# contrail_compute_mode - the values are bare_metal to have bare_metal agent setup and "container" for agent container
# default is bare_metal
# contrail_compute_mode: bare_metal
contrail_compute_mode: container
 
# os_release - operating system release - ubuntu 14.04 - ubuntu14.04, ubuntu 16.04 - ubuntu16.04, centos 7.1 - centos7.1, centos 7.2 - centos7.2
os_release: ubuntu14.04
 
# contrail version
contrail_version: 4.0.0.0-3059
 
# cloud_orchestrator - cloud orchestrators to be setup
# Valid cloud orchestrators:
# kubernetes, mesos, openstack, openshift
cloud_orchestrator: kubernetes
 
# vrouter physical interface
vrouter_physical_interface: eno1
 
# custom image for kube-manager - image with ubuntu 16.04 and systemd
# contrail_kube_manager_image: 10.84.34.155:5000/contrail-kube-manager-u16.04:4.0.0.0-3016
 
# custom image for mesos-manager - image with ubuntu 16.04 and systemd
# contrail_mesos_manager_image: 10.84.34.155:5000/contrail-mesos-manager-u16.04:4.0.0.0-3016
 
 
# controller_ip can be load ballanced IP, or one of the controller_list
# if not configured, ansible use first ip address from [contrail-controllers]
# controller_ip: 192.168.0.22
 
##################
# Below config params (i.e the variables named .*_config) are used to configure contrailctl
# All of below variables are a dict which form individual section of contrailctl/*.conf (controller.conf, agent.conf, etc)
# they are just a dictionary form of config files found under contrailctl/*
# Please refer examples/fully_commented_inventory for full list of variables available
###################
 
# global_config: controller_list, analytics_list, analyticsdb_list etc would be automatically detected by ansible code based out of hosts file host group sections
#  e.g controller_list is all ips added under [contrail-controllers]
#   This vars will be configured in [GLOBAL] section of all contrailctl config files (contrailctl/*.conf)
 
# global_config:
 
# To configure custom webui http port
webui_config: {http_listen_port: 8085}
 
###################################################
# Openshift specific configuration
##
# openshift_config: {token: <openshift token>}
 
###################################################
# Openstack specific configuration
##
# contrail_install_packages_url: "http://10.84.5.120/github-build/mainline/3023/ubuntu-14-04/mitaka/contrail-install-packages_4.0.0.0-3023~mitaka_all.deb"
# keystone_config: {ip: 192.168.0.23, admin_password: contrail123}
EOF
```

#### 4.2 - bis (if you don't have a container registry set up) Download the images in a folder on the ansible client 
```
mkdir container_images/
copy Contrail containers .tgz images in this folder
comment out the docker registry lines in inventory/my-inventory/group_vars/all.yml
```
#### 4.3 Run the Ansible playbook 
```
ansible-playbook -i inventory/my-inventory site.yml
```

### 5. Install Kubernetes using Kubeadm
```
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
 
setenforce 0
 
yum update

yum install -y kubelet kubeadm kubectl kubernetes-cni
```

edit /etc/systemd/system/kubelet.service.d/10-kubeadm.conf:
- (on the Master) Comment or remove the KUBELET_NETWORK_ARGS in /etc/systemd/system/kubelet.service.d/10-kubeadm.conf.
- (all master and slaves) Add a flag “--cgroup-driver=systemd” to the KUBELET_KUBECONFIG_ARGS and KUBELET_SYSTEM_PODS_ARGS in
```
systemctl daemon-reload
systemctl enable kubelet && systemctl start kubelet

(on the master) kubeadm init
(on the slaves) kubeadm join --token <token> <master-ip>:<master-port>
 
(on the master) Enable the insecure-port value to 8080 and --insecure-bind-address=0.0.0.0 in /etc/kubernetes/manifests/kube-apiserver.yaml
(on the master) service kubelet restart
(on the master – for kubectl) cd $HOME
(on the master – for kubectl) cp /etc/kubernetes/admin.conf $HOME/
(on the master – for kubectl) sudo chown $(id -u):$(id -g) $HOME/admin.conf
(on the master – for kubectl) export KUBECONFIG=$HOME/admin.conf
```

### 6. Run Applications 
Load examples 
```
git clone https://github.com/gtesseyre/kubernetes-demo.git
cd kubernetes-demo
```
Start a web application and the kubernetes dashboard
```
kubectl create -f default-pod-service/contrail-frontend.yaml
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml
```
And then edit the kubernetes dashboard service to configure a LoadBalancer so that the Kubernetes dashboard gets an External IP and is accessible from outside
