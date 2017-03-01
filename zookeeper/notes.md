#Zookeeper cheatsheet

How to check who is the leader
```
cat /var/log/zookeeper/zookeeper.log | grep LEAD
```
or
```
echo stat | nc localhost 2181 | grep Mode
```
How to display the connected clients 
```
echo stat | nc localhost 2181
```

Start Zookeeper CLI 
```
/usr/share/zookeeper/bin/zkCli.sh
```
```
Connecting to localhost:2181
Welcome to ZooKeeper!
JLine support is enabled

WATCHER::

WatchedEvent state:SyncConnected type:None path:null
[zk: localhost:2181(CONNECTED) 0]
```

Browse through from the CLI : ls /xxx/yyy/zzz, for example : 
```
[zk: localhost:2181(CONNECTED) 12] ls /fq-name-to-uuid/

route_target:target:64512:8000004
config_node:default-global-system-config:node-5.domain.tld
route_target:target:64512:8000005
service_appliance:default-global-system-config:default-service-appliance-set:default-service-appliance
security_group:default-domain:services:default
route_target:target:64512:8000000
[...]
```

Read content from the CLI : get /xxx/yyy/zzz, for example :
```
[zk: localhost:2181(CONNECTED) 8] get /fq-name-to-uuid/virtual_network:default-domain:admin:admin_internal_net
c1738c63-8d6a-4f35-8461-e0732f10b90e
cZxid = 0x1000000f4
ctime = Mon Feb 20 20:44:47 UTC 2017
mZxid = 0x1000000f4
mtime = Mon Feb 20 20:44:47 UTC 2017
pZxid = 0x1000000f4
cversion = 0
dataVersion = 0
aclVersion = 0
ephemeralOwner = 0x0
dataLength = 36
numChildren = 0
```


