#!/bin/bash
VM="attckervm"
URI="qemu:///system"

# Check if VM is running
if virsh --connect "$URI" domstate "$VM" | grep -q running; then
  # VM already running → just attach
  virt-viewer --full-screen --connect "$URI" --domain-name "$VM"
else
  # VM not running → start then attach
  virsh --connect "$URI" start "$VM"
  virt-viewer --full-screen --connect "$URI" --domain-name "$VM"
fi
