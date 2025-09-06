#!/usr/bin/env bash

dir="$HOME/.local/share/screenshots"
mkdir -p "$dir"

timestamp=$(date +'%Y-%m-%d_%H-%M-%S')

case "$1" in
full)
  file="$dir/screenshot-$timestamp.png"
  if grim "$file"; then
    notify-send -i "$file" "📸 Screenshot saved" "$file"
  else
    notify-send "❌ Screenshot failed" "Could not capture full screen"
  fi
  ;;
area)
  file="$dir/screenshot-$timestamp.png"
  # Capture → edit in swappy, allow saving or just copying
  grim -g "$(slurp)" - | swappy -f -

  ;;
esac
