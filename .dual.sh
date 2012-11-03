#!/usr/bin/env zsh
hdmi=$(xrandr --query | egrep -om1 '^HDMI[0-9]')
if [[ -n $hdmi ]]; then
xrandr --output LVDS1 --mode 1366x768 --pos 0x0 --output HDMI1 --mode 1920x1080 --pos 1366x0
fi
