FROM buildpack-deps:buster AS isolate
RUN apt-get update && \
    apt-get install -y --no-install-recommends git libcap-dev && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /tmp/isolate && \
    git clone https://github.com/envicutor/isolate.git /tmp/isolate/ && \
    cd /tmp/isolate && \
    git checkout af6db68042c3aa0ded80787fbb78bc0846ea2114 && \
    make -j$(nproc) install && \
    rm -rf /tmp/*

FROM node:15.10.0-buster-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y libxml2 gnupg tar coreutils util-linux libc6-dev \
    binutils build-essential locales libpcre3-dev python3 curl && \
    rm -rf /var/lib/apt/lists/*

# Setup directories and permissions
RUN mkdir -p /piston && \
    mkdir -p /piston_api && \
    useradd -m piston && \
    chown -R piston:piston /piston

# Copy files
WORKDIR /piston_api
COPY ["package.json", "package-lock.json", "./"]
RUN npm install
COPY ./src ./src
COPY ./cli ./cli

# Make scripts executable
COPY ./src/install-runtimes.sh /piston_api/src/
COPY ./src/docker-entrypoint.sh /piston_api/src/
RUN chmod +x /piston_api/src/docker-entrypoint.sh && \
    chmod +x /piston_api/src/install-runtimes.sh

EXPOSE 80
CMD ["/piston_api/src/docker-entrypoint.sh"]
