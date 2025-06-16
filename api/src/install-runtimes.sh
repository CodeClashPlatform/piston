#!/bin/bash

# Log function for better visibility
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Set working directory
cd /piston_api

log "Starting runtime installations..."

# Create packages directory if it doesn't exist
mkdir -p /piston/packages

# Install runtimes
log "Installing Python runtime..."
node cli/index.js ppman install python@3.9.0
log "Installing Java runtime..."
node cli/index.js ppman install java@15.0.2
log "Installing Node.js runtime..."
node cli/index.js ppman install nodejs@15.0.0

log "Setting permissions..."
chown -R piston:piston /piston/packages

log "Runtime installations completed"
log "Installed runtimes:"
node cli/index.js ppman list