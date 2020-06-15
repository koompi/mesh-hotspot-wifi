```
DEV: 001
Title: Static ip address
Author: Heng Hongsea
Status: Active
Create: 2020-06-15
Update: NA
version: 0.1.0
```

# Static ip address

You need edit config on this path:  `/etc/network/interface`

```console
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
   address <ip address>
   netmask <netmask>
   gateway <gateway>
   
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