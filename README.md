# Network

This branch contains the code and the configurations of the Network module of DemoJ

----


## The server

> Default port is 5000

> The local address of this module is fixed to 192.168.64.101 

### The config file structure

todo


### Requests :

#### Control

- ```GET /restart/<module>``` Order to restart a module (server, network or terminal)

- ```GET /stop/<module>``` Order to stop a module

- ```GET /ping/<module>``` Ping a module

- ```GET /check_status/<module>``` Get the status of a module (active or inactive)

#### Configuration

- ```GET /config``` Returns the config json file

- ```GET /modules/<module>/params/<id_param>``` Returns the module parameter such as the packet loss or the latency


## Dependencies 

- Flask (for the HTTP server)