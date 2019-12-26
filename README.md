# Linux_Scripts
Repository for Linux Scripts
###### cross-compiler_install.sh
: This script is used to compile into the ARM Architecture source code on a desktop PC(x86 or x64).

###### selective_adhocMode.sh
How to use:
su root
chmod +x selective_adhocMode.sh
./selective_adhocMode.sh
sudo reboot

Description:
The script was written using Raspberry Pi 3 and contains the following: If there is no WiFi which are enable to connect in the neighborhood,
it will automatically switch to ad-Hoc(hostspot) mode. However, this will only work at boot time.
if If you want to switch to ad-Hoc and wifi connection mode manually, you can switch to scripts for these two (ad-hoc-mode.sh and
wifi-connection-mode.sh).
#### And if you saw the message "Failed to start hostapd.service: Unit hostapd.service is masked" at boot time,
#### an error occurred in the hostapd package. So run hostapd_error.sh.
