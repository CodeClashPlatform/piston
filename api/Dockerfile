FROM ghcr.io/engineer-man/piston

WORKDIR /piston_api

# Copy CLI and package files first
COPY cli ./cli
COPY package*.json ./

# Install dependencies and CLI globally
RUN npm install && \
    npm install -g ./cli

# Copy rest of the application
COPY . .

# Setup scripts
COPY src/install-runtimes.sh src/
COPY src/docker-entrypoint.sh src/
RUN chmod +x src/install-runtimes.sh src/docker-entrypoint.sh

ENTRYPOINT ["/piston_api/src/docker-entrypoint.sh"]
