#!/bin/bash
VM="attckervm"

# Check if the VM is already running
if virsh --connect qemu:///system domstate "$VM" | grep -q running; then
  # VM is running, just attach console via virt-manager
  virt-manager --connect qemu:///system --show-domain-console attckervm
else
  # VM is off → start it, then attach console
  virsh --connect qemu:///system start "$VM"
  sleep 3 # small delay to let it boot
  virt-manager --connect qemu:///system --show-domain-console attckervm
fi
