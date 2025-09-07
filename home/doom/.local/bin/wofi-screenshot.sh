#!/usr/bin/env bash
# wofi-screenshot-swappy.sh
# Menu: Take a snip | 3 second wait | 5 second wait
# Capture -> open in swappy (no save)

set -u
set -o pipefail

WOFI_CMD="wofi --dmenu -p Screenshot"
SLURP_CMD="$(command -v slurp || true)"
GRIM_CMD="$(command -v grim || true)"
SWAPPY_CMD="$(command -v swappy || true)"
NOTIFY_CMD="$(command -v notify-send || true)"

if [[ -z "$SLURP_CMD" || -z "$GRIM_CMD" || -z "$SWAPPY_CMD" ]]; then
  echo "Error: slurp, grim and swappy are required." >&2
  [[ -n "$NOTIFY_CMD" ]] && notify-send "Screenshot" "Install grim, slurp and swappy."
  exit 1
fi

# show menu
CHOICE=$(printf "Take a snip\n3 second wait\n5 second wait" | eval "$WOFI_CMD")
# cancelled
if [[ -z "$CHOICE" ]]; then
  exit 0
fi

countdown_notify() {
  local sec="$1"
  if [[ -n "$NOTIFY_CMD" ]]; then
    for ((i = sec; i > 0; i--)); do
      notify-send -a Screenshot "Taking screenshot in $i..."
      sleep 1
    done
  else
    sleep "$sec"
  fi
}

take_and_open_swappy() {
  # get geometry from slurp (area selection)
  # slurp returns non-zero/empty if cancelled
  geom="$($SLURP_CMD)" || geom=""
  if [[ -z "$geom" ]]; then
    [[ -n "$NOTIFY_CMD" ]] && notify-send "Screenshot" "Cancelled."
    return 0
  fi

  # pipe PNG from grim into swappy
  # grim writes to stdout with "-" and swappy reads from stdin with -f -
  if ! $GRIM_CMD -g "$geom" - | $SWAPPY_CMD -f -; then
    [[ -n "$NOTIFY_CMD" ]] && notify-send "Screenshot" "Failed to open swappy."
    return 1
  fi
}

case "$CHOICE" in
"Take a snip")
  take_and_open_swappy
  ;;
"3 second wait")
  countdown_notify 3
  take_and_open_swappy
  ;;
"5 second wait")
  countdown_notify 5
  take_and_open_swappy
  ;;
*)
  exit 0
  ;;
esac
