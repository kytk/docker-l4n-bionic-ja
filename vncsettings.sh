#!/bin/bash
# A script to set vncserver and novnc
# Usage: $0 <resolution>
# resolution should be something like 1920x1080
# K. Nemoto 19 Apr 2021

if [ $# -lt 1 ]; then
  RESOLUTION=1280x800
else
  RESOLUTION=$1
fi

USER=brain vncserver :1 -geometry ${RESOLUTION} -depth 24
sudo websockify -D --web=/usr/share/novnc/ 80 localhost:5901

