FROM ubuntu:18.04

ENV container=docker \
    TZ=America/Sao_Paulo \
    TERM=xterm \
    DEBIAN_FRONTEND=noninteractive

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

# installing required packages
RUN apt-get -qq update && \
    apt-get install -y apt-utils systemd software-properties-common jq sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN systemctl set-default multi-user.target && \
    systemctl mask dev-hugepages.mount sys-fs-fuse-connections.mount && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Systemd defines that it expects SIGRTMIN+3 for graceful shutdown
# https://www.commandlinux.com/man-page/man1/systemd.1.html#lbAH
STOPSIGNAL SIGRTMIN+3

# initialize systemd
# Workaround for docker/docker#27202, technique based on comments from docker/docker#9212
CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]

## References
## https://hub.docker.com/r/solita/ubuntu-systemd/dockerfile
