# systemd - centos7

How to run:

```shell
docker build -t danielneto/systemd:centos7 .

docker run -td \
--security-opt seccomp=unconfined \
--cap-add SYS_ADMIN \
--tmpfs /tmp --tmpfs /run \
-v /sys/fs/cgroup:/sys/fs/cgroup:ro \
-v /sys/fs/fuse/connections:/sys/fs/fuse/connections \
-v /dev/hugepages:/dev/hugepages \
danielneto/systemd:centos7
```

or just use [docker-compose](https://docs.docker.com/compose/install/):

```shell
docker-compose up -d --build centos7
```
