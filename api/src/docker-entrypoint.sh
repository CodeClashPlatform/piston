#!/bin/bash

CGROUP_FS="/tmp/cgroup"
mkdir -p $CGROUP_FS

if [ ! -e "$CGROUP_FS/cgroup.subtree_control" ]; then
  echo "Creating cgroup v2 structure in $CGROUP_FS"
  mkdir -p "$CGROUP_FS/isolate/init"
fi

cd $CGROUP_FS && \
echo 1 > isolate/cgroup.procs && \
echo '+cpuset +cpu +io +memory +pids' > cgroup.subtree_control && \
cd isolate && \
echo 1 > init/cgroup.procs && \
echo '+cpuset +memory' > cgroup.subtree_control

echo "Initialized cgroup" && \
chown -R piston:piston /tmp/piston && \
exec su -- piston -c 'ulimit -n 65536 && node /piston_api/src'