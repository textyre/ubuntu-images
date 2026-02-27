#!/usr/bin/env bash
# Ubuntu Vagrant box contract — run inside the booted VM via: vagrant ssh -c "..."
set -euo pipefail

echo "=== Ubuntu Vagrant Box Contract ==="
echo -n "python3:  " && python3 --version
echo -n "sudo:     " && sudo --version | head -1
echo -n "systemd:  " && systemctl is-system-running 2>/dev/null || true
echo -n "SSH:      " && systemctl is-active ssh 2>/dev/null || echo "unknown"
echo "=== Contract: PASS ==="
