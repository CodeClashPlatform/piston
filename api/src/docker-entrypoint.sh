#!/bin/bash

# Set up required directories
PISTON_DIR="/tmp/piston"
mkdir -p $PISTON_DIR
chmod 755 $PISTON_DIR
chown -R piston:piston $PISTON_DIR

# Set up environment
PORT=${PORT:-80}
export PISTON_BIND_ADDRESS="0.0.0.0:$PORT"

# Start the application
exec su -s /bin/bash piston -c "cd /piston_api && node src/index.js"