# Centos with Systemd

This is a workaround for running custom commands on docker with systemd.

## How to Run

The idea here is to override the custom-init.sh by a CI tool

```bash
docker run --rm -ti --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro centos:custom-systemd
```