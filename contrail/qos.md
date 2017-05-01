### How many queues are on my compute ? 
```
tc -s class show dev p514p2 | grep : | wc -l
```

### Output for a specific queue ? 
```
tc -s class show dev p514p2 | grep -A3 :39
```
or 
```
ethtool -S p514p2 | grep tx_queue_56_packets
```

### How to watch all your queues at the same time ? 
```
watch -d "ethtool -S p514p2 | grep 'tx_queue_0_packets\|tx_queue_1_packets\|tx_queue_8_packets\|tx_queue_16_packets\|tx_queue_24_packets\|tx_queue_32_packets\|tx_queue_40_packets\|tx_queue_48_packets\|tx_queue_56_packets' ”
```

### How to verify the bandwidth/strictness parameters that are applied ? 
```
qosmap --get-queue p514p2 
```

### How to verify the vrouter mapping between logical and physical queues ? 
```
http://<$VROUTER_IP>::8085/Snh_KForwardingClassReq
```

### How to verify the vrouter agent mapping between forwarding classes and logical queues ? 
```
http://<$VROUTER_IP>:8085/Snh_ForwardingClassSandeshReq
```

### How to verify QoS config applied on the vrouter 
```
http://<$VROUTER_IP>:8085/Snh_KQosConfigReq
```

### Generate traffic in a with a ToS to verify if it is classified in the correct CoS ? 
```
ping -Q 40 10.10.10.4 -c 10
```

For troubleshooting purposes it is a good habit to maintain a table with the different attributes of the situation you’re investigation (FC / logical queue / hardware queue / decimal queue value / hexadecimal queue value / DSCP / 802.1p / EXP / ToS). You don’t have to but it makes debugging easier as there is a lot of information in different places and with different pointers/references. 
