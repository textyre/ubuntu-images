# ubuntu-images

Ubuntu 24.04 base image with systemd for Ansible/Molecule testing.

## What this image contains

| Package | Version | Why |
|---------|---------|-----|
| systemd + systemd-sysv | 24.04 LTS | Molecule systemd driver + service testing |
| python3 | 24.04 LTS | Ansible connection + modules |
| python3-apt | 24.04 LTS | Ansible `apt` module support |
| sudo | 24.04 LTS | Privilege escalation in test playbooks |
| dbus | 24.04 LTS | systemd dbus socket (required for systemctl) |
| udev | 24.04 LTS | Device management (required for network roles) |
| kmod | 24.04 LTS | Kernel module management |

## Guarantees

Every image push is contract-tested. The following are always true:

- `/lib/systemd/systemd` is executable
- `python3`, `sudo`, `udevadm`, `kmod`, `dbus-daemon` are on PATH
- `python3 -c "import apt"` succeeds
- `/lib/systemd/system/systemd-tmpfiles-setup.service` exists

## Contract tests

- Docker: [`contracts/docker.sh`](contracts/docker.sh) — runs inside the built image
- Vagrant: [`contracts/vagrant.sh`](contracts/vagrant.sh) — runs inside a booted VM via `vagrant ssh`

## Usage

### In molecule.yml (Docker driver)

```yaml
platforms:
  - name: ubuntu-instance
    image: ghcr.io/textyre/ubuntu-base:24.04
    command: /lib/systemd/systemd
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    privileged: true
    pre_build_image: true
```

### As a Vagrant box

```ruby
# Vagrantfile
config.vm.box = "ubuntu-base"
config.vm.box_url = "https://github.com/textyre/ubuntu-images/releases/download/boxes/ubuntu-base-latest.box"
```

### In molecule.yml (Vagrant driver)

```yaml
platforms:
  - name: ubuntu-base
    box: ubuntu-base
    box_url: https://github.com/textyre/ubuntu-images/releases/download/boxes/ubuntu-base-latest.box
```

## Not suitable for

- Production deployments of any kind
- Environments without Docker privileged mode
- Images where a minimal footprint is required

## Update schedule

Rebuilt every Monday at 03:00 UTC (1 hour after arch-images, 02:00 UTC).
Based on `ubuntu:24.04` LTS — rebuilt to pick up upstream security patches.

## Image tags

| Tag | Example | Use |
|-----|---------|-----|
| `:latest` | `ubuntu-base:latest` | Local development |
| `:YYYY.MM.DD` | `ubuntu-base:2026.02.27` | Pin to a specific weekly build |
| `:24.04` | `ubuntu-base:24.04` | Semantic Ubuntu LTS version |
| `:sha-{short}` | `ubuntu-base:sha-abc1234` | Immutable pin for rollback |
