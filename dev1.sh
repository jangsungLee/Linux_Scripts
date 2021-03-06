#!/bin/sh
# for Linux

sudo apt-get update
sudo apt-get install -y fonts-unfonts-core xrdp cheese fswebcam build-essential x264 qtcreator qt5-default libqt5* qml-module-qtquick-controls2 wiringpi
git clone https://github.com/jangsungLee/DoorLock.git
mkdir /home/pi/doorLock-build1
cp -R DoorLock/* /home/pi/doorLock-build1
cd /home/pi/doorLock-build1
qmake && make

mkdir /home/pi/pigpio
cd /home/pi/pigpio
wget https://github.com/joan2937/pigpio/archive/master.zip
unzip master.zip
cd pigpio-master
make
sudo make install

sudo apt-get install gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools libgstreamer1.0-dev libgstreamer1.0-0-dbg libgstreamer1.0-0 libgstreamer-plugins-base1.0-dev gtk-doc-tools


# source url : https://imsoftpro.tistory.com/53
#mkdir /pi/home/gstreamer_devgstreamer_dev

#cd /pi/home/gstreamer_dev
#sudo apt-get install gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools libgstreamer1.0-dev libgstreamer1.0-0-dbg libgstreamer1.0-0 libgstreamer-plugins-base1.0-dev gtk-doc-tools
#git clone https://github.com/thaytan/gst-rpicamsrc.git
#cd gst-rpicamsrc
#./autogen.sh
#make
#sudo make install

#cd /pi/home/gstreamer_dev
#git clone git://anongit.freedesktop.org/gstreamer/gst-rtsp-server
#cd gst-rtsp-server
#git checkout 1.4
#./autogen.sh
#make
#sudo make install
