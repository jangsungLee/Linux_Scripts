#!/bin/sh
# for Linux

sudo apt-get install -y cheese fswebcam build-essential x264 qtcreator qt5-default libqt5* qml-module-qtquick-controls2

# source url : https://imsoftpro.tistory.com/53
mkdir /pi/home/gstreamer_devgstreamer_dev

cd /pi/home/gstreamer_dev
sudo apt-get install gstreamer1.0-plugins-bad gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly gstreamer1.0-tools libgstreamer1.0-dev libgstreamer1.0-0-dbg libgstreamer1.0-0 libgstreamer-plugins-base1.0-dev gtk-doc-tools
git clone https://github.com/thaytan/gst-rpicamsrc.git
cd gst-rpicamsrc
./autogen.sh
make
sudo make install

cd /pi/home/gstreamer_dev
git clone git://anongit.freedesktop.org/gstreamer/gst-rtsp-server
cd gst-rtsp-server
git checkout 1.4
./autogen.sh
make
sudo make install
