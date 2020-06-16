```
DEV: 001
Title: Hostapd
Author: Heng Hongsea
Status: Active
Create: 2020-06-16
Update: NA
version: 0.1.0
```

# Hostapd

### Install and deploy hostapd 

Hostapd allows your computer to function as an Access Point (AP) WPA/WPA2 Authenticator. Since debian-based systems have pre-packaged version of hostapd, a simple command will install this package

```console
sudo apt-get install hostapd
sudo echo 'DAEMON_CONF="/etc/hostapd/hostapd.conf"' >> /etc/default/hostapd
sudo vim /etc/hostapd/hostapd.conf
```

Change the following parameters in `hostapd.conf` file.

```console
interface=wlan1
driver=nl80211
ssid=MyWiFiHotspot
hw_mode=g
channel=6
macaddr_acl=0
auth_algs=1
beacon_int=100
dtim_period=2
rts_threshold=2347
fragm_threshold=2346
#ignore_broadcast_ssid=0
```
**_Note:  You have to delete all the comments in the hostpad config file. Hostapd doesn't support comments in the config file._**

Test and start hostapd: 

```console
sudo hostapd -d /etc/hostapd/hostapd.conf
```

If all goes well, the hostapd daemon should start and not quit.

```console
sudo systemctl restart hostapd.service
sudo systemctl enable hostapd.service
```

If you had issues trying to start hostapd in Ubuntu desktop, run the following command:

```console
sudo nmcli radio wifi off
sudo rfkill unblock wlan
sudo systemctl start hostapd
sudo systemctl status hostapd
```