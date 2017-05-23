### 1. MX configuration for ECMP Load Balancing
```
interfaces {
    lt-0/0/0 {
    [...]
        unit 300 {
            encapsulation frame-relay;
            dlci 100;
            peer-unit 400;
            family inet;
        }
        unit 400 {
            encapsulation frame-relay;
            dlci 100;
            peer-unit 300;
            family inet;
        
routing-options {
    static {
        route 0.0.0.0/0 next-hop 10.84.31.62;
        route 10.84.31.32/28 next-hop lt-0/0/0.300;
    }
    [...]
    autonomous-system 64512;
    forwarding-table {
        export pplb;
        }
    }
    [...]
    dynamic-tunnels {
        overlay_tunnels {
            source-address 10.84.29.253;
            gre;
            destination-networks {
                10.84.29.0/24;
            }
        }
    
[...]

protocols {
[...]
    bgp {
   [...]
        group kubernetes-guilhem {
            type internal;
            local-address 10.84.29.253;
            hold-time 90;
            keep all;
            family inet-vpn {
                unicast;
            }
            family inet6-vpn {
                unicast;
            }
            family evpn {
                signaling;
            }
            family route-target;
            multipath;
            neighbor 10.84.29.40;
        }

policy-options {
    policy-statement pplb {
        term 1 {
            then {
                load-balance per-packet;
                accept;
            }
        }
    }
}

routing-instances {
    [...]
    kubernetes-guilhem-public {
        instance-type vrf;
        interface lt-0/0/0.400;
        vrf-target target:64512:10123;
        vrf-table-label;
        routing-options {
            static {
                route 0.0.0.0/0 next-hop lt-0/0/0.400;
            }
            multipath {
                vpn-unequal-cost;
            }
        }
    }
     
```

### 2. contrail-kube-manager configuration for FIP pool + project/VN segmentation 
```
root@b7s40(controller):/# cat /etc/contrail/contrail-kubernetes.conf
[VNC]
cassandra_server_list = 10.84.29.40:9161
rabbit_server = 10.84.29.40:5672
vnc_endpoint_port = 8082
collectors = 10.84.29.40:8086
admin_user = admin
admin_password = admin
vnc_endpoint_ip = 10.84.29.40
public_fip_pool = {'project': 'default-project', 'domain': 'default-domain', 'network': '__public__', 'name': '__fip_pool_public__'}
admin_tenant = admin
[AUTH]
auth_user = admin
auth_tenant = admin
auth_password = admin
auth_token_url = http://10.84.29.40:35357/v2.0/tokens
[KUBERNETES]
kubernetes_api_server = 127.0.0.1
kubernetes_api_secure_port = 6443
kubernetes_api_port = 8080
cluster_name = k8s-default
#cluster_project = {'project': 'default', 'domain': 'default-domain'}
kubernetes_api_secure_ip = 10.84.29.40
pod_subnets = 10.32.0.0/12
service_subnets = 10.96.0.0/12
[DEFAULTS]
log_level = SYS_DEBUG
log_local = 1
orchestrator = kubernetes
log_file = /var/log/contrail/contrail-kube-manager.log
token =
```
