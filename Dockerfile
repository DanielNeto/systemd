FROM centos:7

ENV container docker

LABEL maintainer="Daniel Neto <daniel.neto at rnp.br>"

# Don't start any optional services except for the few we need.
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

STOPSIGNAL SIGRTMIN+3

# setting systemd boot target
# multi-user.target: analogous to runlevel 3, Text mode
RUN systemctl set-default multi-user.target

# those require extra volumes and capabilities to work, are they really necessary?
# ref: http://libfuse.github.io/doxygen/
# ref: https://wiki.debian.org/Hugepages
#
# if you really need dev-hugepages.mount:
# 1 - unmask this unit
# 2 - mount volume /dev/hugepages:/dev/hugepages when docker run
# 3 - add capability SYS_ADMIN
#
# if you really need sys-fs-fuse-connections.mount:
# 1 - unmask this unit
# 2 - mount volume sys/fs/fuse/connections:/sys/fs/fuse/connections when docker run
# 3 - add capability SYS_ADMIN (maybe not necessary)
#
# obs> masked is a stronger disabled state
RUN systemctl mask dev-hugepages.mount sys-fs-fuse-connections.mount

CMD ["/usr/sbin/init"]