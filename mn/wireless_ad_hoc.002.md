```
DEV: 002
Title: Wireless Ad-Hoc Network
Author: Heng Hongsea
Status: Active
Create: 2020-06-15
Update: NA
version: 0.1.0
```

# **Wireless Ad-Hoc Network**

## Node Master

You need edit config on this path:  `/etc/network/interface` and Add this config.

```console   
auto wlan0
allow-hotplug wlan0
iface wlan0 inet static
  address 192.168.10.1
  netmask 255.255.255.0
  gateway 192.168.10.1
  wireless-key 12345678
  wireless-channel 1
  wireless-essid Mymesh
  wireless-mode ad-hoc
```

## Node 1

You need edit config on this path:  `/etc/network/interface` and Add this config.

```console   
auto wlan0
allow-hotplug wlan0
iface wlan0 inet static
  address 192.168.20.1
  netmask 255.255.255.0
  gateway 192.168.20.1
  wireless-key 12345678
  wireless-channel 1
  wireless-essid Mymesh
  wireless-mode ad-hoc
```