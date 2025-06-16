#!/bin/bash

# Set up required directories
CGROUP_FS="/tmp/cgroup"
PISTON_DIR="/piston"

# Create necessary directories
mkdir -p $CGROUP_FS
mkdir -p $PISTON_DIR

if [ ! -e "$CGROUP_FS/cgroup.subtree_control" ]; then
  echo "Creating cgroup v2 structure in $CGROUP_FS"
  mkdir -p "$CGROUP_FS/isolate/init"
fi

# Setup cgroups
cd $CGROUP_FS && \
echo 1 > isolate/cgroup.procs && \
echo '+cpuset +cpu +io +memory +pids' > cgroup.subtree_control && \
cd isolate && \
echo 1 > init/cgroup.procs && \
echo '+cpuset +memory' > cgroup.subtree_control

# Set proper permissions
echo "Initializing directories and permissions..."
chown -R piston:piston $PISTON_DIR
echo "Initialized cgroup and permissions"

# Start the application
exec su -- piston -c 'ulimit -n 65536 && node /piston_api/src'