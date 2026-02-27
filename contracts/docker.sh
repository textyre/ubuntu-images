#!/usr/bin/env bash
# Ubuntu Docker image contract — run inside container:
#   docker run --rm <image> sh -c "$(cat contracts/docker.sh)"
set -euo pipefail

echo "=== Ubuntu Docker Image Contract ==="
echo -n "systemd:  " && test -x /lib/systemd/systemd && echo "OK"
echo -n "python3:  " && python3 --version
echo -n "sudo:     " && sudo --version | head -1
echo "=== Contract: PASS ==="
