```
DEV: 002
Title: Wireless Ad-Hoc Network
Author: Heng Hongsea
Status: Active
Create: 2020-06-15
Update: NA
version: 0.1.0
```

# Wireless Ad-Hoc Network

You need edit config on this path:  `/etc/network/interface` and Add this config.

```console   
auto wlan0
allow-hotplug wlan0
iface wlan0 inet static
  address <ip address>
  netmask <netmask>
  gateway <gateway>
  wireless-key <password>
  wireless-channel 1
  wireless-essid <SSID>
  wireless-mode ad-hoc
```