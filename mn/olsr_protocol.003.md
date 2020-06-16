```
MN: 001
Title: Olsrd protocol
Author: Heng Hongsea
Status: Active
Create: 2020-06-15
Update: NA
version: 0.1.0
```

# Olsrd protocol

## Require

```
sudo apt install olsrd
```

We will start config on two node (node1, node2)


## Node 1

### Enable olsrd start on boot

uncomment the line in `/etc/default/olsrd`

```console
START_OLSRD=YES
```

### Restart service

```console
sudo systemctl restart networking
```

### olsrd config

You need edit olsrd config on this path:  `/etc/olsrd/olsrd.conf`

```console
Hna4
{
    192.168.1.0   255.255.255.0
    192.168.10.0  255.255.255.0
    192.168.20.0  255.255.255.0

}


...

IpcConnect
{
     Host            192.168.10.1
     Host            192.168.20.1 
}
```
#Node 2
### Enable olsrd start on boot

uncomment the line in `/etc/default/olsrd`

```console
START_OLSRD=YES
```

### Restart service

```console
sudo systemctl restart networking
```

### olsrd config

You need edit olsrd config on this path:  `/etc/olsrd/olsrd.conf`

```console
Hna4
{
    192.168.10.0  255.255.255.0
    192.168.20.0  255.255.255.0
}

...

IpcConnect
{
     Host            192.168.10.1
     Host            192.168.20.1   
}

```
