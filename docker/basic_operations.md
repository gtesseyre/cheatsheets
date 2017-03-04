*(If you do not name your container you will have to replace the name by the container ID instead)* 

###Launch a container 
```
docker run -itd --name=<CONTAINER_NAME> gtesseyre/<CONTAINER_IMAGE_NAME>
```

###Execute a shell in a container 
```
docker exec -it <CONTAINER_NAME> /bin/bash
```

###Stop a container 
```
docker stop <CONTAINER_NAME>
```

###Delete a container 
```
docker rm <CONTAINER_NAME>
```

###Inspect container logs
```
docker logs <CONTAINER_NAME>
```

###Commit changes in the container to create an image on the local repo 
```
docker commit <CONTAINER_NAME> gtesseyre/<CONTAINER_IMAGE_NAME>:<TAG>
```

###Push container image to Docker Hub 
```
docker push gtesseyre/<CONTAINER_IMAGE_NAME>:<TAG>
```
