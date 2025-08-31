#!/bin/sh

focused_ws=$(hyprctl activeworkspace -j | jq -r .name)

if [ "$focused_ws" = "special:magic" ]; then
  # Find the workspace you were on before entering special
  last_ws=$(hyprctl workspaces -j | jq -r '.[] | select(.id >= 1) | .name' | head -n1)
  if [ -n "$last_ws" ]; then
    hyprctl dispatch movetoworkspace "$last_ws"
  else
    hyprctl dispatch movetoworkspace +1
  fi
else
  hyprctl dispatch movetoworkspace special:magic
fi
