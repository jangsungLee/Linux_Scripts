#!/bin/bash

if [ $(id -u) -ne 0 ]; then exec sudo bash "$0" "$@"; exit; fi

AP_NAME=myAP
AP_PASSWORD=raspberry

args=("$@")
if [ $# -gt 0 ];then
        AP_NAME=${args[0]}
fi

if [ $# -gt 1 ];then
        AP_PASSWORD=${args[1]}
fi


echo -e "\033[36m"apt-get update"\033[0m"
sudo apt-get update -y
echo -e "\033[36m"apt-get upgrade"\033[0m"
sudo apt-get upgrade -y
echo -e "\033[36m"apt-get install dnsmasq hostapd"\033[0m"
sudo apt-get install -y dnsmasq hostapd

echo -e "\033[36m""\033[0m"
echo -e "\033[36m"editting /etc/dhcpcd.conf"\033[0m"
sudo echo "" >> /etc/dhcpcd.conf
sudo echo "interface wlan0" >> /etc/dhcpcd.conf
sudo echo "static ip_address=192.168.4.1/24" >> /etc/dhcpcd.conf
sudo echo "static routers=192.168.4.1" >> /etc/dhcpcd.conf
sudo echo "static domain_name_servers=8.8.8.8" >> /etc/dhcpcd.conf


echo -e "\033[36m"editting /etc/hostapd.conf"\033[0m"
sudo echo "interface=wlan0" >> /etc/hostapd.conf
sudo echo "driver=nl80211" >> /etc/hostapd.conf
sudo echo "ssid=$AP_NAME" >> /etc/hostapd.conf
sudo echo "wpa_passphrase=$AP_PASSWORD" >> /etc/hostapd.conf
sudo echo "hw_mode=g" >> /etc/hostapd.conf
sudo echo "channel=7" >> /etc/hostapd.conf
sudo echo "auth_algs=1" >> /etc/hostapd.conf
sudo echo "ieee80211n=1" >> /etc/hostapd.conf
sudo echo "wmm_enabled=1" >> /etc/hostapd.conf
sudo echo "ht_capab=[HT40][SHORT-GI-20][DSSS_CCK-40]" >> /etc/hostapd.conf
sudo echo "macaddr_acl=0" >> /etc/hostapd.conf
sudo echo "ignore_broadcast_ssid=0" >> /etc/hostapd.conf
sudo echo "wpa=2" >> /etc/hostapd.conf
sudo echo "wpa_key_mgmt=WPA-PSK" >> /etc/hostapd.conf
sudo echo "rsn_pairwise=CCMP" >> /etc/hostapd.conf

echo -e "\033[36m"editting /etc/default/hostapd - (hostapd configs)"\033[0m"
sudo sed -i  's/\#DAEMON_CONF\=\"\"/DAEMON_CONF\=\"\/etc\/hostapd\/hostapd.conf\"/' /etc/default/hostapd

echo -e "\033[36m"/etc/dnsmasq.conf is backup into /etc/dnsmasq.conf.original"\033[0m"
sudo cp /etc/dnsmasq.conf /etc/dnsmasq.conf.original
echo -e "\033[36m"editting /etc/dnsmasq.conf"\033[0m"
sudo echo "" >> /etc/dnsmasq.conf
sudo echo "interface=wlan0" >> /etc/dnsmasq.conf
sudo echo "listen-address=192.168.4.1" >> /etc/dnsmasq.conf
sudo echo "domain-needed" >> /etc/dnsmasq.conf
sudo echo "server=8.8.8.8" >> /etc/dnsmasq.conf
sudo echo "bogus-priv" >> /etc/dnsmasq.conf
sudo echo "dhcp-range=192.168.4.30,192.168.4.100,24h" >> /etc/dnsmasq.conf

echo -e "\033[36m"editting /etc/sysctl.conf - (for ip forward configs)"\033[0m"
sudo sed -i 's/\#net.ipv4.ip_forward\=1/net.ipv4.ip_forward\=1/' /etc/sysctl.conf

sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT

sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
echo -e "\033[36m"editting /etc/rc.local"\033[0m"
sudo cp /etc/rc.local /etc/rc.local.original
sudo sed -i 's/exit 0/iptables\-restore \< \/etc\/iptables\.ipv4\.nat\n\n exit 0/' /etc/rc.local