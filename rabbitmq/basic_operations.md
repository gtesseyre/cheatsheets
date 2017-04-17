###Display RabbitMQ Status 
```
rabbitmqctl cluster_status
```

###Display RabbitMQ Queues  
```
rabbitmqctl list_queues
```

###Display RabbitMQ Bindings  
```
rabbitmqctl list_bindings
```

###Customized for Contrail 
```
rabbitmqctl list_bindings | grep 'vnc\|dev\|mon\|schema'
```
```
rabbitmqctl list_queues | grep 'vnc\|dev\|mon\|schema'
```
