#Setup the repo
```
sudo apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
    
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -

sudo add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       ubuntu-$(lsb_release -cs) \
       main"
```

#Install Docker
```
sudo apt-get update
sudo apt-get -y install docker-engine
```


#Uninstall Docker 
```
sudo apt-get purge docker-engine
sudo rm -rf /var/lib/docker
```
