FROM ghcr.io/engineer-man/piston

WORKDIR /piston_api

# Copy entire project
COPY . .

# Install dependencies and CLI globally
RUN cd cli && npm install && cd .. && \
    npm install -g ./cli

# Setup scripts
RUN chmod +x api/src/install-runtimes.sh api/src/docker-entrypoint.sh

EXPOSE 2000

ENTRYPOINT ["api/src/docker-entrypoint.sh"]
