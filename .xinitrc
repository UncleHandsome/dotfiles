#!/bin/zsh
[ -f /etc/xprofile ] && . /etc/xprofile
[ -f ~/.xprofile] && . ~/.xprofile
xset +fp /usr/share/fonts/local
xset fp rehash
zsh ~/.dual.sh
zsh ~/.fehbg
xbacklight -set 30
xcompmgr -cC &
#xbindkeys
amixer sset Master unmute
amixer sset Headphone unmute
xrdb ~/.Xresources
autocutsel -fork &
export XMODIFIERS=@im=gcin
export LC_CTYPE=zh_TW.UTF-8
gcin &
#skype &
xscreensaver -no-splash &
DEFAULT_SESSION=awesome
case $1 in
  awesome|wmii|xmonad) exec $1 ;;
  *) exec $DEFAULT_SESSION ;;
esac
