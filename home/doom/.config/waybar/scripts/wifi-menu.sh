#!/bin/sh
choice=$(nmcli --terse --fields SSID,SIGNAL device wifi list | sort -k2 -n -r |
  awk -F: '{print $1 " (" $2 "%)"}' | wofi -i -p "WiFi")
# strip the signal part to get SSID (this depends on the format)
ssid=$(printf "%s" "$choice" | sed -E 's/ \([0-9]+%\)$//')
[ -n "$ssid" ] && nmcli device wifi connect "$ssid"
