#!/usr/bin/env bash

# Check tun0 (OpenVPN interface)
if ip addr show tun0 &>/dev/null; then
  ip=$(ip -4 addr show tun0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
  if [ -n "$ip" ]; then
    echo "  $ip"
    exit 0
  fi
fi
