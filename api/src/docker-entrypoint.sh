#!/bin/bash

# Function for logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Error handling
set -e
trap 'log "Error on line $LINENO"' ERR

# Set up required directories
CGROUP_FS="/tmp/cgroup"
PISTON_DIR="/piston"

log "Setting up directories..."
# Create necessary directories with proper permissions
mkdir -p $CGROUP_FS
mkdir -p $PISTON_DIR
mkdir -p $PISTON_DIR/packages

# Set directory permissions
log "Setting directory permissions..."
chmod 755 $PISTON_DIR
chmod 755 $PISTON_DIR/packages
chown -R piston:piston $PISTON_DIR
chown -R piston:piston $CGROUP_FS

# Setup cgroups
log "Setting up cgroups..."
if [ ! -e "$CGROUP_FS/cgroup.subtree_control" ]; then
    log "Creating cgroup v2 structure in $CGROUP_FS"
    mkdir -p "$CGROUP_FS/isolate/init"
    
    cd $CGROUP_FS
    echo 1 > isolate/cgroup.procs || log "Warning: Failed to write to cgroup.procs"
    echo '+cpuset +cpu +io +memory +pids' > cgroup.subtree_control || log "Warning: Failed to write to subtree_control"
    
    cd isolate
    echo 1 > init/cgroup.procs || log "Warning: Failed to write to init/cgroup.procs"
    echo '+cpuset +memory' > cgroup.subtree_control || log "Warning: Failed to write to subtree_control"
fi

# Check and install runtimes if needed
log "Checking runtimes..."
if [ ! -d "$PISTON_DIR/packages/python" ]; then
    log "Installing runtimes..."
    bash /piston_api/src/install-runtimes.sh || log "Warning: Runtime installation failed"
fi

# Configure system limits
log "Configuring system limits..."
ulimit -n 65536

# Set up environment
log "Setting up environment..."
PORT=${PORT:-80}
export PISTON_BIND_ADDRESS="0.0.0.0:$PORT"

log "Starting Piston API..."
# Start the application as piston user
exec su -s /bin/bash piston -c "cd /piston_api && node src/index.js"