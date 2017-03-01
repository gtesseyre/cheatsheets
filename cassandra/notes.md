#Cassandra cheatsheet

###Using Nodetool
Display the status of the Cassandra cluster 
```
nodetool status
```

Display stats for the different keyspaces
```
nodetool cfstats
```

Get a list of the different keyspaces from nodetool
```
nodetool cfstats | grep Keyspace
```

###Using pycassa shell
Use pycassa shell to look into a keyspace 
```
pycassaShell -H $CASSANDRA_IP -k $KEYSPACE_NAME
```
For example: 
```
root@5b3s25:~# pycassaShell -H 10.87.64.26 -k config_db_uuid
[I]: IPython not found, falling back to default interpreter.
----------------------------------
Cassandra Interactive Python Shell
----------------------------------
Keyspace: config_db_uuid
Host: 10.87.64.26:9160

Available ColumnFamily instances:
 * OBJ_FQ_NAME_TABLE          ( obj_fq_name_table )
 * OBJ_SHARED_TABLE           ( obj_shared_table )
 * OBJ_UUID_TABLE             ( obj_uuid_table )
 
Schema definition tools and cluster information are available through SYSTEM_MANAGER.
>>>
```
From the pycassa shell use the available functions to read/manipulate data. 
```
>>> dir()
['ASCII_TYPE', 'BOOLEAN_TYPE', 'BYTES_TYPE', 'COUNTER_COLUMN_TYPE', 'CfDef', 'ColumnDef', 'Connection', 'DATE_TYPE', 'DECIMAL_TYPE', 'DOUBLE_TYPE', 'FLOAT_TYPE', 'INT_TYPE', 'IndexType', 'InteractiveSystemManager', 'KEYS_INDEX', 'KsDef', 'LEXICAL_UUID_TYPE', 'LONG_TYPE', 'NETWORK_TOPOLOGY_STRATEGY', 'OBJ_FQ_NAME_TABLE', 'OBJ_SHARED_TABLE', 'OBJ_UUID_TABLE', 'OLD_NETWORK_TOPOLOGY_STRATEGY', 'SIMPLE_STRATEGY', 'SYSTEM_MANAGER', 'SchemaDisagreementException', 'SystemManager', 'TIME_UUID_TYPE', 'UTF8_TYPE', '__builtins__', '__doc__', '__name__', '__package__', '_make_line', '_pool', '_print_line', '_update_cf', 'args', 'cfinstance', 'cfname', 'credentials', 'default_socket_factory', 'default_transport_factory', 'describe_column_family', 'describe_keyspace', 'exit', 'framed', 'hostname', 'marshal', 'options', 'optparse', 'parser', 'port', 'pycassa', 'runshell', 'spaces', 'stderr', 'stdout', 'time', 'types']
```
For example, listing all virtual networks  
```
>>> OBJ_FQ_NAME_TABLE.get('virtual_network')
OrderedDict([('default-domain:default-project:__link_local__:0e376793-2bc0-475e-bf93-c824d0473d3f', u'null'), ('default-domain:default-project:default-virtual-network:9d532a36-5b7e-428c-97ce-8b0925ae65e9', u'null'), ('default-domain:default-project:ip-fabric:d0d2c159-82d6-4c87-99e5-557f054456db', u'null'), ('default-domain:demo:DEMO-public-net:b7e2f2c3-da6c-4b86-981f-7435b3e445c2', u'null'), ('default-domain:demo:test:8633d56f-0517-4234-b13e-9a631e779630', u'null')])
```
Or, reading specific virtual-network information 
```
>>> OBJ_UUID_TABLE.get('8633d56f-0517-4234-b13e-9a631e779630')
OrderedDict([('backref:instance_ip:61cd201b-7991-46f0-9eb4-a985b99fe12c', u'{"is_weakref": false, "attr": null}'), ('backref:virtual_machine_interface:701abb36-a3ee-4a87-88c0-bea84ff069b7', u'{"is_weakref": false, "attr": null}'), ('children:routing_instance:2d7910e2-8c46-485b-99cd-235e6b97c7c2', u'null'), ('fq_name', u'["default-domain", "demo", "test"]'), ('parent:project:837b3532-50a0-4068-b3ac-20cf3464abe5', u'null'), ('parent_type', u'"project"'), ('prop:display_name', u'"test"'), ('prop:ecmp_hashing_include_fields', u'{}'), ('prop:export_route_target_list', u'{"route_target": []}'), ('prop:flood_unknown_unicast', u'false'), ('prop:id_perms', u'{"enable": true, "uuid": {"uuid_mslong": 9670307497698083380, "uuid_lslong": 12771815343772898864}, "created": "2017-02-18T05:15:42.647893", "description": null, "creator": null, "user_visible": true, "last_modified": "2017-02-18T05:15:42.812690", "permissions": {"owner": "admin", "owner_access": 7, "other_access": 7, "group": "admin", "group_access": 7}}'), ('prop:import_route_target_list', u'{"route_target": []}'), ('prop:is_shared', u'false'), ('prop:multi_policy_service_chains_enabled', u'false'), ('prop:perms2', u'{"owner": "837b353250a04068b3ac20cf3464abe5", "owner_access": 7, "global_access": 0, "share": []}'), ('prop:router_external', u'false'), ('prop:virtual_network_network_id', u'4'), ('prop:virtual_network_properties', u'{"mirror_destination": false, "allow_transit": false, "rpf": "enable"}'), ('ref:network_ipam:8db98a27-8c9a-42e6-95d0-465511b7462a', u'{"is_weakref": false, "attr": {"ipam_subnets": [{"subnet": {"ip_prefix": "12.0.0.0", "ip_prefix_len": 24}, "dns_server_address": "12.0.0.2", "enable_dhcp": true, "default_gateway": "12.0.0.1", "subnet_uuid": "19244afa-2cfc-4c6a-902c-29ed66064027", "subnet_name": "19244afa-2cfc-4c6a-902c-29ed66064027", "addr_from_start": true}]}}'), ('type', u'"virtual_network"')])
```

###Using cqlsh
Connect to cqlsh shell
```
# cqlsh 192.168.123.7
Connected to Contrail at 192.168.123.7:9042.
[cqlsh 5.0.1 | Cassandra 2.2.5 | CQL spec 3.3.1 | Native protocol v4]
Use HELP for help.
cqlsh>
```

Display keyspaces 
```
cqlsh> describe keyspaces

"ContrailAnalyticsCql"  config_db_uuid      useragent
"DISCOVERY_SERVER"      to_bgp_keyspace     svc_monitor_keyspace
system_auth             system_distributed  dm_keyspace
system                  system_traces
```

Display keyspaces and their respective replication factor values 
```
cqlsh> select * from system.schema_keyspaces;

 keyspace_name        | durable_writes | strategy_class                              | strategy_options
----------------------+----------------+---------------------------------------------+----------------------------
 ContrailAnalyticsCql |           True | org.apache.cassandra.locator.SimpleStrategy | {"replication_factor":"2"}
          system_auth |           True | org.apache.cassandra.locator.SimpleStrategy | {"replication_factor":"1"}
 svc_monitor_keyspace |           True | org.apache.cassandra.locator.SimpleStrategy | {"replication_factor":"3"}
      to_bgp_keyspace |           True | org.apache.cassandra.locator.SimpleStrategy | {"replication_factor":"3"}
   system_distributed |           True | org.apache.cassandra.locator.SimpleStrategy | {"replication_factor":"3"}
               system |           True |  org.apache.cassandra.locator.LocalStrategy |                         {}
       config_db_uuid |           True | org.apache.cassandra.locator.SimpleStrategy | {"replication_factor":"3"}
          dm_keyspace |           True | org.apache.cassandra.locator.SimpleStrategy | {"replication_factor":"3"}
        system_traces |           True | org.apache.cassandra.locator.SimpleStrategy | {"replication_factor":"2"}
            useragent |           True | org.apache.cassandra.locator.SimpleStrategy | {"replication_factor":"3"}
     DISCOVERY_SERVER |           True | org.apache.cassandra.locator.SimpleStrategy | {"replication_factor":"3"}

(11 rows)
```

Describe tables in the keyspaces
```
cqlsh> describe tables

Keyspace "ContrailAnalyticsCql"
-------------------------------
flowrecordtable        flowtablevrouterver2     statstablebydbltagv3
objectvaluetable       messagetablemessagetype  messagetablekeyword
messagetabletimestamp  messagetablecategory     statstablebyu64strtagv3
statstablebyu64tagv3   messagetablesource       statstablebystrstrtagv3
systemobjecttable      flowtableprotdpver2      statstablebystru64tagv3
objecttable            statstablebyu64u64tagv3  flowtabledvndipver2
messagetable           statstablebystrtagv3     flowtableprotspver2
flowtablesvnsipver2    messagetablemoduleid

Keyspace "DISCOVERY_SERVER"
---------------------------
discovery

Keyspace system_auth
--------------------
resource_role_permissons_index  role_permissions  role_members  roles

Keyspace system
---------------
available_ranges  size_estimates    schema_usertypes    compactions_in_progress
range_xfers       peers             paxos               schema_aggregates
schema_keyspaces  schema_triggers   batchlog            schema_columnfamilies
schema_columns    sstable_activity  schema_functions    local
"IndexInfo"       peer_events       compaction_history  hints

Keyspace config_db_uuid
-----------------------
obj_shared_table  obj_uuid_table  obj_fq_name_table

Keyspace to_bgp_keyspace
------------------------
service_chain_uuid_table        service_chain_table
service_chain_ip_address_table  route_target_table

Keyspace system_distributed
---------------------------
repair_history  parent_repair_history

Keyspace system_traces
----------------------
events  sessions

Keyspace useragent
------------------
useragent_keyval_table

Keyspace svc_monitor_keyspace
-----------------------------
service_instance_table  pool_table

Keyspace dm_keyspace
--------------------
dm_pnf_resource_table  dm_pr_vn_ip_table
```



