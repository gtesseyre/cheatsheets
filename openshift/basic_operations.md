Adding a login/password for a user to log into the UI 
```
htpasswd /etc/origin/master/htpasswd admin
<ENTER YOUR PASSWORD>
```

Adding cluster-admin role privilege to a user 
```
oadm policy add-cluster-role-to-user cluster-admin admin
```
