#!/bin/bash

# Set up directories and permissions
PISTON_ROOT="/piston"
PISTON_TMP="/tmp/piston"

mkdir -p $PISTON_ROOT $PISTON_TMP
chmod 755 $PISTON_ROOT $PISTON_TMP
chown -R piston:piston $PISTON_ROOT $PISTON_TMP

# Install runtimes if not already installed
if [ ! -d "/piston/packages" ]; then
    echo "Installing runtime packages..."
    bash /piston_api/src/install-runtimes.sh
fi

# Configure environment
export PORT=${PORT:-2000}
export PISTON_BIND_ADDRESS="0.0.0.0:$PORT"
export PISTON_DATA_DIRECTORY=$PISTON_ROOT
export PISTON_MAX_CONCURRENT_JOBS=64
export PISTON_DISABLE_NETWORKING=true

# Start API server as piston user
exec su -s /bin/bash piston -c "cd /piston_api && node src/index.js"