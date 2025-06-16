FROM ghcr.io/engineer-man/piston

WORKDIR /piston_api

# Copy package files first
COPY package*.json ./
COPY cli/package*.json ./cli/

# Install CLI dependencies
RUN npm install && \
    cd cli && npm install && cd .. && \
    npm link ./cli

# Copy rest of the application
COPY . .

# Setup scripts
RUN chmod +x api/src/install-runtimes.sh api/src/docker-entrypoint.sh

# Update runtime installation script
RUN sed -i 's/piston-cli/piston/g' api/src/install-runtimes.sh

EXPOSE 2000

ENTRYPOINT ["api/src/docker-entrypoint.sh"]
