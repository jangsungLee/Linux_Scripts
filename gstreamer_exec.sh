#!/bin/sh
# for Linux

gst-launch-1.0 -v v4l2src ! video/x-raw,width=640,height=480 ! videoconvert ! x264enc ! rtph264pay ! udpsink host=127.0.0.1 port=5000
