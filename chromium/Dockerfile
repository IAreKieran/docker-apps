FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
      chromium-browser \
    && rm -rf /var/lib/apt/lists/*

# Add docker-apps user
ARG HOST_USER_ID
ARG HOST_USER_GID
RUN groupadd -r -g $HOST_USER_GID docker-apps && useradd -r -u $HOST_USER_ID -g docker-apps -G audio,video docker-apps \
    && mkdir -p /home/docker-apps/Downloads && chown -R docker-apps:docker-apps /home/docker-apps

# Run as non privileged user
USER docker-apps

ENTRYPOINT ["/usr/bin/chromium-browser"]
