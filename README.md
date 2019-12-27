# Linux_Scripts  
Repository for Linux Scripts  
## cross-compiler_install.sh  
: This script is used to compile into the ARM Architecture source code on a desktop PC(x86 or x64).  
  
## selective_adhocMode.sh  
How to use:  
su root  
chmod +x selective_adhocMode.sh  
./selective_adhocMode.sh       OR       ./selective_adhocMode.sh ap_name ap_password  
sudo reboot  

How to enable/disable  
: nano /etc/selective_adhocMode/config  
  operation=OFF (if you want to disable)  


Description:  
The script was written using Raspberry Pi 3 and contains the following: If there is no WiFi which are enable to connect in the   neighborhood,  
it will automatically switch to ad-Hoc(hostspot) mode. However, this will only work at boot time.  
if If you want to switch to ad-Hoc and wifi connection mode manually, you can switch to scripts for these two (ad-hoc-mode.sh and
wifi-connection-mode.sh).  
###### default AP Name : RPI3wifi, AP Password : 1234567890  
#### And if you saw the message "Failed to start hostapd.service: Unit hostapd.service is masked" at boot time,  
#### an error occurred in the hostapd package. So run hostapd_error.sh.  
  
#### 연결할 wifi목록을 작성하는 방법
: After installation, enter the "sudo nano /etc/rc.local" and amend the line 42nd, which reads ssids=( 'mySSID1' 'mySSID2'). If your wifi is asus1, iptime, work_AP, you can modify it to ssids=( 'asus1' 'iptime' 'work_AP' ). You can also write the password for each AP in "/etc/wpa_suppliant/wpa_suppliant.conf". The attention point should have a small value of 'priority' in a small order. The AP 'asus1' should have the highest value of Priority.
#### /etc/wpa_suppliant/wpa_suppliant.conf
network={  
        ssid="asus1"  
        psk="abcd1234"  
        priority=3 # priority   
}  
network={  
        ssid="iptime"  
        psk="12345678"  
        priority=2 # priority   
}   
network={  
        ssid="work_AP"  
        psk="abcd1234"  
        priority=1 # priority   
}  
###### 이 스크립트가 동작하기 위해 작성되어지는 곳
/etc/hostapd/hostapd.conf (초기에는 존재하지 않고, 내가 직접 생성해준것임)  
/etc/default/hostapd  
/etc/dnsmasq.conf   
/etc/network/interfaces  
/etc/rc.local  
/etc/sysctl.conf  
