
### 1. Create a file with your environment information and credentials 

```
export OS_USERNAME=<FILL_WITH_YOUR_USERNAME>
export OS_PASSWORD=<FILL_WITH_YOUR_PASSWORD>
export OS_TENANT_NAME=<FILL_WITH_YOUR_TENANT_NAME>
export KEYSTONE_IP=<FILL_WITH_YOUR_KEYSTONE_IP>
export CONFIG_IP=<FILL_WITH_YOUR_CONTRAIL_CONFIG_API_IP>
export CONFIG_PORT=<FILL_WITH_YOUR_CONTRAIL_CONFIG_API_PORT>
export ANALYTICS_IP=<FILL_WITH_YOUR_CONTRAIL_ANALYTICS_API_IP>
export ANALYTICS_PORT=<FILL_WITH_YOUR_CONTRAIL_ANALYTICS_API_PORT>

REQUEST="{\"auth\": {\"tenantName\":\"$OS_TENANT_NAME\", \"passwordCredentials\": {\"username\": \"$OS_USERNAME\", \"password\": \"$OS_PASSWORD\"}}}"
RAW_TOKEN=`curl -s -d "$REQUEST" -H "Content-type: application/json" "http://$KEYSTONE_IP:5000/v2.0/tokens"`
TOKEN=`echo $RAW_TOKEN | python -c "import sys; import json; tok = json.loads(sys.stdin.read()); print tok['access']['token']['id'];"`
export TOKEN
echo "Token was issued"
echo $TOKEN
```

### 2. Load the environment variables and get a token (previously created file)
```
source credentials
```

### 3. Run requests toward Contrail Config API - Example request to display all configured virtual-networks
```
curl -X GET -H "X-Auth-Token: $TOKEN" http://$CONFIG_IP:$CONFIG_PORT/virtual-networks | python -m json.tool
```

### 4. Run requests toward Contrail Analytics API - Example request to display all virtual-networks UVEs
```
curl -X GET -H "X-Auth-Token: $TOKEN" http://$ANALYTICS_IP:$ANALYTICS_PORT/analytics/uves/virtual-networks | python -m json.tool
```
