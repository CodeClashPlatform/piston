#!/bin/bash

# Set up required directories
CGROUP_FS="/tmp/cgroup"
PISTON_DIR="/piston"

# Create necessary directories with proper permissions
mkdir -p $CGROUP_FS
mkdir -p $PISTON_DIR
mkdir -p $PISTON_DIR/packages

# Set directory permissions
chmod 755 $PISTON_DIR
chmod 755 $PISTON_DIR/packages
chown -R piston:piston $PISTON_DIR
chown -R piston:piston $CGROUP_FS

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

echo "Initialized cgroup and permissions"

# Start the application with proper port binding
PORT=${PORT:-80}
export PISTON_BIND_ADDRESS="0.0.0.0:$PORT"

exec su -s /bin/bash piston -c "ulimit -n 65536 && node /piston_api/src"