###Move into the client folder 
```
cd /cs-shared/server-manager/client/
```

###Display images already registered in Server Manager
```
server-manager show image
```

###Display basic information about your server
```
server-manager show server --server_id <SERVER_NAME>
```

###Display detailed information about your server
```
server-manager show server --server_id <SERVER_NAME> --detail
```
###Re-image your server with a specific image 
```
  server-manager reimage --server_id <SERVER_NAME> <IMAGE_NAME>
```

###Delete server entry in server manager using the IP  
```
server-manager delete server --ip <SERVER_IP>
```

###Delete server entry in server manager using the ID  
```
server-manager delete server --server_id <SERVER_NAME>
```

###Add server entry in server manager using a json file   
```
server-manager add server -f 5b5s17

gtesseyre@svrmgr:/var/tmp$ cat 5b5s17
{
    "server": [
        {
            "base_image_id": "",
            "cluster_id": "",
            "contrail": {
                "control_data_interface": "em1"
            },
            "discovered": "false",
            "domain": "contrail.juniper.net",
            "email": null,
            "gateway": "10.87.65.126",
            "host_name": "5b5s17",
            "id": "5b5s17",
            "intf_bond": null,
            "intf_control": null,
            "intf_data": null,
            "ip_address": "10.87.65.20",
            "ipmi_address": "10.87.122.113",
            "ipmi_interface": null,
            "ipmi_password": "ADMIN",
            "ipmi_type": "",
            "ipmi_username": "ADMIN",
            "mac_address": "90:e2:ba:ca:db:9d",
            "ssh_public_key": "ssh-rsa $PUBLIC_KEY_DATA",
 	    "password":"$PASSWORD",
            "network": {
                "management_interface": "em1",
		"provisioning": "kickstart",
                "interfaces": [
                    {
                        "default_gateway": "10.87.65.126",
                        "dhcp": true,
                        "ip_address": "10.87.65.20/25",
                        "mac_address": "90:e2:ba:ca:db:9d",
                        "name": "em1",
                        "type": "physical"
                    }
                ]
	    }
        }
    ]
}

```
