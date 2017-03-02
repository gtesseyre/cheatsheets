###Random shell commands 

Simple FOR loop - usefull to start/delete a couple VM/containers/images, for example 
```
for i in a313a91a404b 0524e0259aa0 aae97a5d0acd; do docker rmi $i ; done
```
