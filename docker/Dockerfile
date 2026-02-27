FROM ubuntu:24.04

ENV container=docker DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      systemd systemd-sysv sudo python3 python3-apt \
      dbus udev kmod && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Trim unnecessary systemd units for Docker (same pattern as arch-images)
RUN (cd /lib/systemd/system/sysinit.target.wants/ && \
     for i in *; do \
       [ "$i" = "systemd-tmpfiles-setup.service" ] || rm -f "$i"; \
     done) && \
    rm -f /lib/systemd/system/multi-user.target.wants/* && \
    rm -f /etc/systemd/system/*.wants/* && \
    rm -f /lib/systemd/system/local-fs.target.wants/* && \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* && \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* && \
    rm -f /lib/systemd/system/basic.target.wants/*

STOPSIGNAL SIGRTMIN+3
VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
