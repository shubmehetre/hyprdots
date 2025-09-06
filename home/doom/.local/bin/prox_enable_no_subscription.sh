#!/bin/sh
set -e

# 1) detect suite: prefer existing .sources info, fall back to lsb_release
SUITE=""
# check known files
if [ -f /etc/apt/sources.list.d/pve-enterprise.sources ]; then
  SUITE=$(sed -n '1,80p' /etc/apt/sources.list.d/pve-enterprise.sources | awk -F': ' '/Suites:/{print $2; exit}')
fi
if [ -z "$SUITE" ] && [ -f /etc/apt/sources.list.d/debian.sources ]; then
  SUITE=$(sed -n '1,80p' /etc/apt/sources.list.d/debian.sources | awk -F': ' '/Suites:/{print $2; exit}')
fi
# fallback to distro codename if still empty
if [ -z "$SUITE" ]; then
  if command -v lsb_release >/dev/null 2>&1; then
    SUITE=$(lsb_release -sc)
  else
    # safe default (you can change if you know your release)
    SUITE="trixie"
  fi
fi

echo "Using suite: $SUITE"

# 2) backup directory for original files (idempotent)
BACKUP_DIR=/root/apt-sources-backup-$(date +%s)
mkdir -p "$BACKUP_DIR"
echo "Backing up proxmox-related source files to $BACKUP_DIR"

# move/disable enterprise sources if found
for f in /etc/apt/sources.list.d/*pve*enterprise* /etc/apt/sources.list.d/*ceph*enterprise*; do
  [ -f "$f" ] || continue
  mv -v "$f" "$BACKUP_DIR/$(basename "$f").disabled"
done

# also move any .list named pve-enterprise.list or ceph.list if present
for f in /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/ceph.list; do
  [ -f "$f" ] && mv -v "$f" "$BACKUP_DIR/$(basename "$f").disabled"
done

# 3) create pve-no-subscription.list (idempotent)
NO_SUB_FILE=/etc/apt/sources.list.d/pve-no-subscription.list
cat >"$NO_SUB_FILE" <<EOF
deb http://download.proxmox.com/debian/pve $SUITE pve-no-subscription
EOF
chmod 644 "$NO_SUB_FILE"
echo "Wrote $NO_SUB_FILE"

# 4) optional: do not auto-create ceph repo unless user needs it
echo "If you run Ceph on this host and want the ceph no-subscription repo, create /etc/apt/sources.list.d/ceph-no-subscription.list"

# 5) run apt update and capture output
echo "Running apt update..."
if apt update; then
  echo "apt update succeeded."
  echo "Now run: apt full-upgrade -y  (or apt upgrade) to upgrade packages."
  exit 0
fi

# If apt update fails, show last lines and advice
echo "apt update returned non-zero. Show the last 50 lines of apt update output for debugging:"
apt update 2>&1 | sed -n '1,200p' || true
exit 1
