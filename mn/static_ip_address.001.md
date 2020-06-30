```
DEV: 001
Title: Static ip address
Author: Heng Hongsea
Status: Active
Create: 2020-06-15
Update: NA
version: 0.1.0
```

# **Static ip address**


## Node Master

You need edit config on this path:  `/etc/network/interface`

```console
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
   address 192.168.10.1
   netmask 255.255.255.0
   gateway 192.168.10.1
```

## Node 1

You need edit config on this path:  `/etc/network/interface`

```console
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
   address 192.168.20.1
   netmask 255.255.255.0
   gateway 192.168.20.1
```