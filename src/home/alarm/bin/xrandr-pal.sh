#!/bin/sh

# http://ubuntuforums.org/showthread.php?t=1649156
#
# https://www.mythtv.org/wiki/Modeline_Database#PAL625_itu-r.2Fbt:_470_601_656

xrandr --output default --prop
xrandr --output default --set "tv standard" pal
xrandr --newmode "720x576@25i" 13.5 720 732 795 864 576 581 586 625 interlace -hsync -vsync
xrandr --addmode default "720x576@25i"
xrandr --output default --mode "720x576@25i"
