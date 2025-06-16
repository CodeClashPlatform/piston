#!/bin/bash

# Log function for better visibility
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting runtime installations..."

# Create packages directory if it doesn't exist
mkdir -p /piston/packages
chmod 755 /piston/packages

# Set paths
export PATH="/usr/local/bin:$PATH"
export NODE_PATH=/usr/local/lib/node_modules

# Install core runtimes using global CLI
log "Installing Python runtime..."
piston-cli ppman install python=3.9.4

log "Installing Node.js runtime..."
piston-cli ppman install nodejs=16.14.0

log "Installing Java runtime..."
piston-cli ppman install java=17.0.2

# Set proper permissions
log "Setting permissions..."
chown -R piston:piston /piston/packages
chmod -R 755 /piston/packages

log "Runtime installations completed"
log "Installed runtimes:"
piston-cli ppman list