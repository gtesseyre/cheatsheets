###Install Yum utils 
```
sudo yum install -y yum-utils
```

###Setup the repo 
```
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

###Install Docker CE
```
sudo yum makecache fast
sudo yum list docker-ce.x86_64  --showduplicates |sort -r
sudo yum install docker-ce-<VERSION>
```

###Start Docker 
```
sudo systemctl start docker
```

###Verify it is running
```
sudo docker run hello-world
```
