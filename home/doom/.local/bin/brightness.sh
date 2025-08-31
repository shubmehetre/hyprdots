#!/usr/bin/env bash
# brightness.sh - adjust external monitor brightness via ddcutil
# Usage: brightness.sh up | down

STEP=15
CUR=$(ddcutil getvcp 10 | grep -oP "current value =\s*\K[0-9]+")

case "$1" in
up)
  NEW=$((CUR + STEP))
  [ $NEW -gt 100 ] && NEW=100
  ;;
down)
  NEW=$((CUR - STEP))
  [ $NEW -lt 0 ] && NEW=0
  ;;
*)
  echo "Usage: $0 {up|down}" >&2
  exit 1
  ;;
esac

ddcutil setvcp 10 $NEW
