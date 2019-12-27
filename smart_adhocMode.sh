#!/bin/bash

AP_NAME=RPI3wifi
AP_PASSWORD=1234567890

args=("$@")
if [ $# -gt 0 ];then
        AP_NAME=${args[0]}
fi

if [ $# -gt 1 ];then
        AP_PASSWORD=${args[1]}
fi

if [ $(id -u) -ne 0 ]; then
	echo "Please run as root."
	exit
fi

echo -e "\033[36m"apt-get update"\033[0m"
sudo apt-get update -y

echo -e "\033[36m"apt-get install hostapd dnsmasq"\033[0m"
sudo apt-get install hostapd -y
sudo apt-get install dnsmasq -y

sudo systemctl disable hostapd
sudo systemctl disable dnsmasq

echo -e "\033[36m""\033[0m"
echo -e "\033[36m"editting /etc/hostapd/hostapd.conf"\033[0m"
sudo echo "interface=wlan0" >> /etc/hostapd/hostapd.conf
sudo echo "driver=nl80211" >> /etc/hostapd/hostapd.conf
sudo echo "ssid=$AP_NAME" >> /etc/hostapd/hostapd.conf
sudo echo "hw_mode=g" >> /etc/hostapd/hostapd.conf
sudo echo "channel=6" >> /etc/hostapd/hostapd.conf
sudo echo "wmm_enabled=0" >> /etc/hostapd/hostapd.conf
sudo echo "macaddr_acl=0" >> /etc/hostapd/hostapd.conf
sudo echo "auth_algs=1" >> /etc/hostapd/hostapd.conf
sudo echo "wpa=2" >> /etc/hostapd/hostapd.conf
sudo echo "wpa_passphrase=$AP_PASSWORD" >> /etc/hostapd/hostapd.conf
sudo echo "wpa_key_mgmt=WPA-PSK" >> /etc/hostapd/hostapd.conf
sudo echo "wpa_pairwise=TKIP" >> /etc/hostapd/hostapd.conf
sudo echo "rsn_pairwise=CCMP" >> /etc/hostapd/hostapd.conf

echo -e "\033[36m"editting /etc/default/hostapd - \(config\)"\033[0m"
sudo sed -i  's/\#DAEMON_CONF\=\"\"/DAEMON_CONF\=\"\/etc\/hostapd\/hostapd.conf\"/' /etc/default/hostapd

echo -e "\033[36m"editting /etc/dnsmasq.conf"\033[0m"
sudo echo "" >>  /etc/dnsmasq.conf
sudo echo "#Pi3Hotspot Config" >> /etc/dnsmasq.conf
sudo echo "#stop DNSmasq from using resolv.conf" >> /etc/dnsmasq.conf
sudo echo "no-resolv" >> /etc/dnsmasq.conf
sudo echo "#Interface to use" >> /etc/dnsmasq.conf
sudo echo "interface=wlan0" >> /etc/dnsmasq.conf
sudo echo "bind-interfaces" >> /etc/dnsmasq.conf
sudo echo "dhcp-range=192.168.4.2,192.168.4.254,24h" >> /etc/dnsmasq.conf
sudo echo "server=8.8.8.8" >> /etc/dnsmasq.conf

echo -e "\033[36m"editting /etc/network/interfaces"\033[0m"
sudo echo "" >> /etc/network/interfaces
sudo echo "allow-hotplug wlan0" >> /etc/network/interfaces
sudo echo "iface wlan0 inet manual" >> /etc/network/interfaces
sudo echo "#wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf" >> /etc/network/interfaces

echo -e "\033[36m"editting routing between eth0 and wlan0"\033[0m"
sudo sed -i 's/\#net.ipv4.ip_forward\=1/net.ipv4.ip_forward\=1/' /etc/sysctl.conf
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT  
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"

mkdir /etc/selective_adhocMode
echo "operation=ON" >> /etc/selective_adhocMode/config
echo "echo -e \"\\033[36m\"               \"\\033[0m\""
COUNT=$(cat /etc/rc.local | wc -l)
STR=$(sed -n $COUNT'p' /etc/rc.local)
if [[ "$STR" == *"exit 0" ]];then
        sed -i 1"s/\#\!\/bin\/sh \-e/\#\!\/bin\/bash \-e/" /etc/rc.local
        sed -i $COUNT"s/exit 0//" /etc/rc.local
        
        echo "#Wifi config - if no prefered Wifi generate a hotspot" >> /etc/rc.local
        echo "#RPi Network Conf Bootstrapper" >> /etc/rc.local
        echo "" >> /etc/rc.local
        echo "createAdHocNetwork()" >> /etc/rc.local
        echo "{" >> /etc/rc.local
        echo "    iptables-restore < /etc/iptables.ipv4.nat" >> /etc/rc.local
        echo "    echo \"Creating RPI Hotspot network\"" >> /etc/rc.local
        echo "    ifconfig wlan0 down" >> /etc/rc.local
        echo "    ifconfig wlan0 192.168.4.1 netmask 255.255.255.0 up" >> /etc/rc.local
        echo "    service dnsmasq start" >> /etc/rc.local
        echo "    service hostapd start" >> /etc/rc.local
        echo "    echo \" \"" >> /etc/rc.local
        echo "    echo \"Hotspot network created\"" >> /etc/rc.local
        echo "    echo \" \"" >> /etc/rc.local
        echo "}" >> /etc/rc.local
        echo "" >> /etc/rc.local
	
	echo "COUNT=\"\$(cat /etc/selective_adhocMode/config | wc -l)\"" >> /etc/rc.local
	echo "operation=false" >> /etc/rc.local
	echo "while [[ \$COUNT -gt 0 ]]" >> /etc/rc.local
	echo "do" >> /etc/rc.local
	echo "     STR=\$(sed -n \$COUNT'p' /etc/selective_adhocMode/config)" >> /etc/rc.local
	echo "     if [[ "\$STR" == *"operation=ON"* ]];" >> /etc/rc.local
	echo "     then" >> /etc/rc.local
	echo "         #echo \"found the message : \$STR\"" >> /etc/rc.local
	echo "         operation=true" >> /etc/rc.local
	echo "         break" >> /etc/rc.local
	echo "     fi" >> /etc/rc.local
	echo "    let COUNT=\$((COUNT -1))" >> /etc/rc.local
	echo "done" >> /etc/rc.local
	echo "" >> /etc/rc.local
	
	echo "if \$operation" >> /etc/rc.local
	echo "then" >> /etc/rc.local
	
        echo "echo \"=================================\"" >> /etc/rc.local
        echo "echo \"RPi Network Conf Bootstrapper\"" >> /etc/rc.local
        echo "echo \"=================================\"" >> /etc/rc.local
        echo "echo \"Scanning for known WiFi networks\"" >> /etc/rc.local
        echo "ssids=( 'mySSID1' 'mySSID2' )" >> /etc/rc.local
        echo "connected=false" >> /etc/rc.local
        echo "for ssid in \"\${ssids[@]}\"" >> /etc/rc.local
        echo "do" >> /etc/rc.local
        echo "    echo \" \"" >> /etc/rc.local
        echo "    echo \"checking if ssid available:\" \$ssid" >> /etc/rc.local
        echo "    echo " "" >> /etc/rc.local
        echo "    if iwlist wlan0 scan | grep \$ssid > /dev/null" >> /etc/rc.local
        echo "    then" >> /etc/rc.local
        echo "        echo \"First WiFi in range has SSID:\" \$ssid" >> /etc/rc.local
        echo "" >> /etc/rc.local
        echo "        check_item=\$(sudo cat /etc/wpa_supplicant/wpa_supplicant.conf | grep \$ssid)" >> /etc/rc.local
        echo "        if [ \${#check_item} -gt 0 ];then" >> /etc/rc.local
        echo "                echo \"Starting supplicant for WPA/WPA2\"" >> /etc/rc.local
        echo "                wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null 2>&1" >> /etc/rc.local
        echo "                echo \"Obtaining IP from DHCP\"" >> /etc/rc.local
        echo "                if dhclient -1 wlan0" >> /etc/rc.local
        echo "                then" >> /etc/rc.local
        echo "                    echo \"Connected to WiFi\"" >> /etc/rc.local
        echo "                    connected=true" >> /etc/rc.local
        echo "                    break" >> /etc/rc.local
        echo "                else" >> /etc/rc.local
        echo "                    echo \"DHCP server did not respond with an IP lease (DHCPOFFER)\"" >> /etc/rc.local
        echo "                    wpa_cli terminate" >> /etc/rc.local
        echo "                    break" >> /etc/rc.local
        echo "                fi" >> /etc/rc.local
        echo "        else" >> /etc/rc.local
        echo "                echo \"There is no the information of \$ssid which is including password.\"" >> /etc/rc.local
        echo "                connected=false" >> /etc/rc.local
        echo "                break" >> /etc/rc.local
        echo "        fi" >> /etc/rc.local
        echo "        unset check_item" >> /etc/rc.local
        echo "     else" >> /etc/rc.local
        echo "       echo \"Not in range, WiFi with SSID:\" \$ssid" >> /etc/rc.local
        echo "    fi" >> /etc/rc.local
        echo "done" >> /etc/rc.local
        echo "" >> /etc/rc.local
        echo "if ! \$connected; then" >> /etc/rc.local
        echo "    createAdHocNetwork" >> /etc/rc.local
        echo "fi" >> /etc/rc.local
        echo "" >> /etc/rc.local
	
	echo "        echo \"YES\"" >> /etc/rc.local
	echo "fi" >> /etc/rc.local

        echo "" >> /etc/rc.local
        echo "exit 0" >> /etc/rc.local


else
         echo "There is no the end line of 'exit 0' in /etc/rc.local. This must be in the end of line"
fi
unset STR
unset COUNT

sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd

echo -e "\033[36m"Installation is finished. Reboot the system."\033[0m"  
