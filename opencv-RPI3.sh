#! /bin/bash

# build apt
sudo apt-get install -y build-essential cmake
# format apt
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
# Codec apt
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev libx264-dev libxine2-dev
# Live-Video-Drivers apt
sudo apt-get install -y libv4l-dev v4l-utils
# GStreamer apt
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev 

sudo apt-get install -y libqt4-dev

sudo apt-get install -y mesa-utils libgl1-mesa-dri libgtkgl2.0-dev libgtkglext1-dev
sudo apt-get install -y libatlas-base-dev gfortran libeigen3-dev

sudo apt-get install -y mesa-utils libgl1-mesa-dri libgtkgl2.0-dev libgtkglext1-dev   

sudo apt-get install opencl-headers -y

sudo apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
sudo apt-get install -y libxvidcore-dev libx264-dev

sudo apt-get install -y libv4l-dev

mkdir /home/pi/opencv
cd /home/pi/opencv
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.1.2.zip
unzip opencv.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.1.2.zip
unzip opencv_contrib.zip
cd opencv-4.1.2
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D WITH_TBB=OFF \
-D WITH_IPP=OFF \
-D WITH_1394=OFF \
-D BUILD_WITH_DEBUG_INFO=OFF \
-D BUILD_DOCS=OFF \
-D INSTALL_C_EXAMPLES=ON \
-D INSTALL_PYTHON_EXAMPLES=ON \
-D BUILD_EXAMPLES=OFF \
-D BUILD_TESTS=OFF \
-D BUILD_PERF_TESTS=OFF \
-D ENABLE_NEON=ON \
-D ENABLE_VFPV3=ON \
-D WITH_QT=OFF \
-D WITH_GTK=ON \
-D WITH_OPENGL=ON \
-D OPENCV_ENABLE_NONFREE=ON \
-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.1.2/modules \
-D WITH_V4L=ON \
-D WITH_FFMPEG=ON \
-D WITH_XINE=ON \
-D ENABLE_PRECOMPILED_HEADERS=OFF \
-D BUILD_NEW_PYTHON_SUPPORT=ON \
-D OPENCV_GENERATE_PKGCONFIG=ON ../


sudo sed -i 's/CONF_SWAPSIZE=100/\# CONF_SWAPSIZE=100\nCONF_SWAPSIZE=2048/' /etc/dphys-swapfile
free
sudo /etc/init.d/dphys-swapfile restart
free

time make -j4
make
sudo make install
sudo ldconfig


sudo sed -i 's/\# CONF_SWAPSIZE=100\nCONF_SWAPSIZE=2048/CONF_SWAPSIZE=100/' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile restart
free