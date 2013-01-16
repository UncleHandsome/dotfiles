#!/bin/zsh
zsh ~/.dual.sh
zsh ~/.fehbg
xset +fp /usr/share/fonts/
xset fp rehash
xbacklight -set 20
xcompmgr -cC &
syndaemon -t -k -i 2 -d &
amixer sset Master unmute
amixer sset Headphone unmute
export XMODIFIERS=@im=gcin
export LC_CTYPE=zh_TW.UTF-8
gcin &
xscreensaver -no-splash &
DEFAULT_SESSION=awesome
case $1 in
  awesome) exec $1 ;;
  *) exec $DEFAULT_SESSION ;;
esac
