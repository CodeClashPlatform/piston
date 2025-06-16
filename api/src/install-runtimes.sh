#!/bin/bash

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting runtime installations..."

# Create packages directory
mkdir -p /piston/packages
chmod 755 /piston/packages

# Set paths
export PATH="/usr/local/bin:$PATH"
export NODE_PATH=/usr/local/lib/node_modules

cd /piston_api

log "Installing Python runtime..."
piston ppman install python=3.9.4

log "Installing Node.js runtime..."
piston ppman install nodejs=16.14.0

log "Installing Java runtime..."
piston ppman install java=17.0.2

log "Setting permissions..."
chown -R piston:piston /piston/packages
chmod -R 755 /piston/packages

log "Runtime installations completed"
log "Installed runtimes:"
piston ppman list