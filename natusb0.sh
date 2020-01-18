#!/bin/sh

# Initial firewall chains.
sudo /etc/rc.d/rc.firewall start

# Drop packets received on the external interface
# claiming a source of the local network
sudo iptables -A bad_packets -p ALL -i wlan0 -s 192.168.42.0/24 -j LOG \
	--log-prefix "Illegal source: "
sudo iptables -A bad_packets -p ALL -i wlan0 -s 192.168.42.0/24 -j DROP

# Return to the calling chain if the bad packets originate
# from the local interface. This maintains the approach
# throughout this firewall of a largely trusted internal
# network.
sudo iptables -A bad_tcp_packets -p tcp -i usb0 -j RETURN

# input ports
#$IPT -A udp_inbound -p UDP -s 0/0 --destination-port 8757 -j ACCEPT

# Rules for the private network (accessing gateway system itself)
sudo iptables -A INPUT -p ALL -i usb0 -s 192.168.42.0/24 -j ACCEPT
sudo iptables -A INPUT -p ALL -i usb0 -d 192.168.42.255 -j ACCEPT
	
# Accept packets we want to forward from internal sources
sudo iptables -A FORWARD -p tcp -i usb0 -j tcp_outbound
sudo iptables -A FORWARD -p udp -i usb0 -j udp_outbound
sudo iptables -A FORWARD -p ALL -i usb0 -j ACCEPT
	
# To internal network
sudo iptables -A OUTPUT -p ALL -s 192.168.42.227 -j ACCEPT
sudo iptables -A OUTPUT -p ALL -o usb0 -j ACCEPT

# POSTROUTING chain
# $IPT -t nat -A POSTROUTING -o $INET_IFACE -j MASQUERADE

# Route 42. to 122.
sudo route del default gw 192.168.42.129

