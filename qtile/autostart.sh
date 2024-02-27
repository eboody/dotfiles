#!/bin/sh
feh --bg-scale /home/eran/Pictures/wallpapers/earth.jpg
picom & disown # --experimental-backends --vsync should prevent screen tearing on most setups if needed

# Low battery notifier
~/.config/qtile/scripts/check_battery.sh & disown

# Start welcome
eos-welcome & disown

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & disown # start polkit agent from GNOME

xset r rate 200 40

noip2 -c ~/no-ip2.conf

/home/eran/scripts/keyboard_setup.sh
/home/eran/scripts/keyboard_poller.sh & disown
emoji-keyboard & disown
