This is just a small procedure to enable external access to VMs running locally via Contrail simple gateway 

1. Create public VN in Contrail - Shared option 

2. Create the simple gateway configuration (interface, routing between the host global routing table and the VRF for the virtual network)
```
python /opt/contrail/utils/provision_vgw_interface.py --oper create --interface vgw-public --subnets 192.168.123.0/24 --routes 0.0.0.0/0 --vrf default-domain:admin:public:public
```

3. Configure NAT on the host to access ressources in the overlay 
```
iptables -t nat -A POSTROUTING -o vhost0 -j MASQUERADE
iptables -A FORWARD -i vgw-public -o vhost0 -j ACCEPT
iptables -A FORWARD -i vhost0 -o vgw-public -m state --state RELATED,ESTABLISHED -j ACCEPT
```

4. Forward a specific port from the host IP to an IP in the overlay 
```
iptables -t nat -I PREROUTING -p tcp -d 10.87.64.27 --dport 9501 -j DNAT --to-destination 192.168.123.5:8080
iptables -I FORWARD -m state -d 192.168.123.0/24 --state NEW,RELATED,ESTABLISHED -j ACCEPT
```

5. Various commands 
5.1 Create a forwarding rule 
```
iptables -t nat -I PREROUTING -p tcp -d 10.87.64.27 --dport 9502 -j DNAT --to-destination 192.168.123.5:80
```
5.2 Delete a forwarding rule 
```
iptables -t nat -D PREROUTING -d 10.87.64.27/32 -p tcp -m tcp --dport 9501 -j DNAT --to-destination 192.168.123.5:8080
```
5.3 Delete the simple gateway configuration 
```
python /opt/contrail/utils/provision_vgw_interface.py --oper delete --interface vgw-public --subnets 192.168.123.0/24 --routes 0.0.0.0/0 --vrf default-domain:admin:public:public
```

