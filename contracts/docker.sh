#!/usr/bin/env bash
# Ubuntu Docker image contract — run inside container:
#   docker run --rm <image> bash contracts/docker.sh
set -euo pipefail

echo "=== ubuntu-base Docker image contract ==="

# Core binaries
echo -n "systemd:          " && test -x /lib/systemd/systemd && echo "OK"
echo -n "python3:          " && python3 --version
echo -n "sudo:             " && sudo --version | head -1

# Explicitly installed packages (per Dockerfile)
echo -n "dbus:             " && command -v dbus-daemon && echo "OK"
echo -n "udev:             " && command -v udevadm && echo "OK"
echo -n "kmod:             " && command -v kmod && echo "OK"
echo -n "python3-apt:      " && python3 -c "import apt; print('OK')"

# Systemd sysv compatibility
echo -n "init (sysv):      " && test -f /sbin/init && echo "OK"

# Systemd minimal (required for Molecule systemd driver)
echo -n "systemd-tmpfiles: " && test -f /lib/systemd/system/systemd-tmpfiles-setup.service && echo "OK"

echo "=== ubuntu-base contract: PASS ==="
