```
DEV: 001
Title: Coovachilli
Author: Heng Hongsea
Status: Active
Create: 2020-06-16
Update: NA
version: 0.1.0
```

### Install first dependency

```console
sudo apt update
```

```console
sudo apt install -y -f debhelper devscripts libcurl4-gnutls-dev haserl g++ gengetopt bash-completion libtool libltdl-dev libjson-c-dev libssl-dev make cmake autoconf automake build-essential dpkg-dev
```

### Download and install the CoovaChilli

```console
wget https://codeload.github.com/coova/coova-chilli/tar.gz/1.5
```

```console
tar xvf 1.5 & cd coova-chilli-1.5 
```

```console
sudo dpkg-buildpackage -us -uc && cd .. 
```

```console
sudo dpkg -i coova-chilli_1.4_armhf.deb
```

### Starting CoovaChilli

Don't forget to enable CoovaChilli to start in `/etc/default/chilli`

```console
START_CHILLI=1
```

Start CoovaChilli, run the following command: 
```console
sudo systemctl start chilli
sudo systemctl enable chilli
```

### Configure CoovaChilli

All configuration files are located under /etc/chilli, You will need to create a config file with your sites modifications.

```console
sudo cp -v /etc/chilli/defaults /etc/chilli/config
sudo  nano /etc/chilli/config
```

Change the following paremeters to match your environment.

```console
###
#   Local Network Configurations
# 

HS_WANIF=wlan0            # WAN Interface toward the Internet
HS_LANIF=wlan1             # Subscriber Interface for client devices
HS_NETWORK=10.10.10.0      # HotSpot Network (must include HS_UAMLISTEN)
HS_NETMASK=255.255.255.0   # HotSpot Network Netmask
HS_UAMALLOW = 10.10.10.0/24
HS_UAMLISTEN=10.10.10.1    # HotSpot IP Address (on subscriber network)
HS_UAMPORT=3990            # HotSpot UAM Port (on subscriber network)
HS_UAMUIPORT=4990          # HotSpot UAM "UI" Port (on subscriber network, for embedded portal)
HS_SSID=MyWiFiHotspot

...

###
#   HotSpot settings for simple Captive Portal
#
HS_NASID=nas01
HS_RADIUS=localhost
HS_RADIUS2=localhost
# HS_UAMALLOW=www.coova.org
HS_RADSECRET=Admin2020    # Set to be your RADIUS shared secret
HS_UAMSECRET=change-me     # Set to be your UAM secret

...

###
#   Firewall issues
# 
#   Uncomment the following to add ports to the allowed local ports list
#   The up.sh script will allow these local ports to be used, while the default
#   is to block all unwanted traffic to the tun/tap. 
HS_TCP_PORTS="80 443"

...

###
#   Standard configurations
HS_ADMUSR=coovachillispot
HS_ADMPWD=coovachillispot
```

### Networking routing
We should not forget to enable packet forwarding and setup NAT (network address translation).

To enable packet forwarding, permanently set forwarding by editing the `/etc/sysctl.conf` file. Find and edit the following line, replacing 0 with 1.

```console
net.ipv4.ip_forward = 1
```

Execute the following command to enable the change to the sysctl.conf file.

```console
sysctl -p /etc/sysctl.conf
```

Edit the file `/etc/chilli/up.sh` with execution permission. At the end of file, paste the following

```console
#Enable NAT
iptables -I POSTROUTING -t nat -o $HS_WANIF -j MASQUERADE
#Others iptables rules when chilli come up
```

### Test it out 

Restart CoovaChilli for the latest change to be effected.

```console
sudo systemctl stop chilli
sudo systemctl start chilli
```