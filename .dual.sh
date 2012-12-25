#!/usr/bin/env zsh
hdmi=$(xrandr --query | egrep -om1 '^HDMI[0-9]')
if [[ -n $hdmi ]]; then
xrandr --output LVDS1 --auto --output HDMI1 --auto --right-of LVDS1
else
        xrandr --output LVDS1 --mode 1366x768 --pos 0x0
fi
