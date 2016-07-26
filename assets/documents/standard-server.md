#Standard Server

## Hardware

Hardware required:

- two network interfaces (one capable of pxe boot)

- two eSATAp hard drives configured in raid1 mirror

- On most machines, there is at least 2GB of RAM included.  Extra RAM increases
  performance and reliability.

### Hardware Configuration

The two external drives are system drives.  The external nature of the drives
doesn't decrease the transfer rates, yet allows easier accessibility.  There is one
primary partition, which is configured as a volume group.  The logical  volumes
default to 10G in size and can be extended as necessary.

A failing drive can be removed and replaced with a same size or larger drive,
and resynced while the system remains up and running.  Upgrading both drives
to larger sizes can be done one drive at a time while the system is still running.

There are two network devices to handle routing and firewalling between the
local network and the internet.


Experience has shown that the hardware that is most likely to fail on a standard
server is a hard drive.  The disruptive effect of a hard drive failure has been
mitigated in this configuration.  Usually, when another piece of hardware fails on
the server, it is more convenient to obtain a newer server.  The software running
the server exists entirely on the external drives and can be used on the new
server with minor adjustments for the newer hardware.


## Basic Services

### Network Management

- Firewall, routing, NAT, Masquerading

- DNS, DHCP

- ip addresses for static hosts are defined in dns zone files and matched to hostname

- dhcp identifies static hosts by MAC and assigns hostname, but no ip.  Only hostname
info shared between DNS and DHCP.

- static hosts do not have to be configured with static address, but can use dhcp

- static hosts that need manual ip config are still named in dns.

- local network configured to address all hosts by name instead of ip address

- longterm management more efficient with proper dns/dhcp configuration

### General Server Policy

- secure shell access is key only / no password

- only ssh exposed to internet by default

- port forwarding should be discouraged, especially to remote desktops

- remote desktop access should be performed through ssh tunnel

- clients needing remote access should use ssl on rdp server

- It would be best to only allow rdp access to signed client certificates, however
this is more difficult for the client to configure and maintain.  Signed ssl
certificates are excellent security measures to prohibit unauthorized access.


