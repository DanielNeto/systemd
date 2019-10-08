FROM centos:7

ENV container docker

LABEL maintainer="Daniel Neto <daniel.neto at rnp.br>"

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

STOPSIGNAL SIGRTMIN+3

# setting systemd boot target
# multi-user.target: analogous to runlevel 3, Text mode
RUN systemctl set-default multi-user.target

CMD ["/usr/sbin/init"]