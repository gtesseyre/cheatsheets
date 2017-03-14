###Display DB list 
```
redis-cli INFO | grep ^db
```

###Display connections information
```
redis-cli INFO | grep connections
```

###Display connected clients 
```
redis-cli INFO | grep connected
```

###Display memory info 
```
redis-cli INFO | grep memory
```

###Display all transactions happening (use carrefully ... especially if there is a lot going on)
```
redis-cli monitor
```

###Display the role of the Redis instance 
```
redis-cli INFO | grep role
```

###Run a benchmark to get some performance indicators
```
redis-benchmark -h <host> [-p <port>]
```

