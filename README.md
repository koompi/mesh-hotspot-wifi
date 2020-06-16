# MESH NETWORK & KOOMPI HOTSPOT

*Node: set up on device `Raspberry Pi 4` and operating system `Raspbian`*


![enter image description here](https://lh3.googleusercontent.com/Ui9JRHSRg5fxsLqz9v2BbYCBHMzQPrSXT8ozozYbsexqpyZGQum-88M-eXlHXUV_b0HQLb_Z6uRI=s1920 "rasAP")
## 1. Mesh Network
The graphic below shows how a wireless mesh network functions when sharings an internet connection. As you see, only one node in the wireless mesh network needs to be directly wired to the internet. That wired node shares the Internet connection wirelessly with the nearest cluster of nodes, which then share it with their nearest cluster of nodes and so on.

### How to set up ?

1. **Static IP Address**: A static ip address is an ip address that was manually configured for a device, versus one that was assigned by a DHCP server. It's called static because it doesn't change. It's the exact opposite of a dynamic IP address, which does change.

2. **Wireless Ad Hoc Network**:  a wireless ad hoc network (WANET) or mobile ad hoc network (MANET) is a decentralized type of wireless network. The network is ad hoc because it does not rely on a pre-existing infrastructure, such as routers in wired network or access points in managed (infrastructure) wireless network. Instead, each node participates in routing by forwarding data for other nodes, so the determination of which nodes forward data is made dynamically on the basis of network connectivity and routing algorithm in use.
3. **OLSR Protocol** : Optimized Like State Routing Protocol (OLSR) such as Open Shortest Path First (OSPF ) and Intermediate System to Intermediate System (IS-IS) elect a designated route on every is different notion of a link, packets in order to optimize the flooding process.Using Hello messages the OLSR protocol at each node discovers 2-hop neighbor information and performs a distributed election of a set multipoint relays(MPRs). Nodes select MPRs such that there exists a path to each of its 2-hop neighbor via a node selected as an MPR. These  MPR nodes then source and formard TC mesages that contain the MPR selectors. This functioning of MPRs makes OLSR unique from other link state routing protocols in a few different ways: The forwarding path for TC messages is not shared among all nodes but varies depending on the source, only a subset of nodes source link state information, not all links of a node are advertised but only those that represent MPR selections.

* MN001 [Static ip address](/mn/static_ip_address.001.md)
* MN002 [Wireless Ad Hoc Network](/mn/wireless_ad_hoc.002.md)
* MN003 [OLSRD Protocol](/mn/olsr_protocol.003.md)

## Koompi Hotspot

1. **Hostapd** :  Host Access point daemon (HOSTAPD) is a user space daemon for access point and authentication servers. It implements IEEE 802.11 access point management, IEEE 802.1X/WPA/WPA2/EAP Authenticators, RADIUS client, EAP server, and RADIUS authentication server.
2. **Freeradius** : FreeRADIUS is a modular, rich in features, highly efficient in performance version. With its multiple AAA servers, it has wide range applications that provide service to millions of users. The server supports LDAP (Lightweight Directory Access Protocol), SQL(Structured Query Language) and other database types and has been operating with EAP (Extensible Authentication Protocol) since 20001 and PEAP (Protected Extensible Authentication Protocol) and EAP-TTLS (EAP-Tunneled Transport Layer Security) since 2003. Currently, the FreeRADIUS supports all ID authentication protocols and data bases.
3. **PostgreSQL** : is a powerful, open source object-relational database system that uses and extends the SQL language combined with many features that safely store and scale the most complicated data workloads.
4. **Coovachilli** : is an open-source software access controller for captive portal (UAM) and 802.1X access provisioning, based on the popular (but now defunct) ChilliSpot project, and is actively maintained by an original ChilliSpot contributor.


