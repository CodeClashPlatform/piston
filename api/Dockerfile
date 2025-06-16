FROM ghcr.io/engineer-man/piston

# Copy application files
WORKDIR /piston_api
COPY . .

# Install dependencies
RUN npm install

# Setup scripts
COPY src/install-runtimes.sh src/
COPY src/docker-entrypoint.sh src/
RUN chmod +x src/install-runtimes.sh src/docker-entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/piston_api/src/docker-entrypoint.sh"]
