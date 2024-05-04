#!/bin/bash
[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
xset +fp /home/ak/.local/share/fonts
xset fp rehash
xsetroot -cursor_name left_ptr
#feh --bg-fill --randomize pics/ &
#$HOME/.config/polybar/launch.sh &
redshift -l 17.42:78.51 -t 6500K:6000K &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
dunst &
sxhkd &
#time.sh &
polybar &

#screen -DR &
#screen -t rtorrent bash -c 'rtorrent' 

#mpd &
/usr/lib/kdeconnectd &
xfce4-power-manager --daemon 
#xfce4-power-manager
exec bspwm
#gammy &
#exec startfluxbox
