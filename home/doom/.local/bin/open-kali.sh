#!/bin/bash
VM="attckervm"

# Check if VM exists
if ! virsh --connect qemu:///system dominfo "$VM" &>/dev/null; then
  echo "Error: VM '$VM' not found."
  exit 1
fi

# Check if the VM is already running
if virsh --connect qemu:///system domstate "$VM" | grep -q running; then
  # VM is running, just attach console via virt-manager
  virt-manager --connect qemu:///system --show-domain-console "$VM"
else
  # VM is off → start it, then attach console
  virsh --connect qemu:///system start "$VM"
  sleep 3 # give it a moment to boot
  virt-manager --connect qemu:///system --show-domain-console "$VM"
fi
