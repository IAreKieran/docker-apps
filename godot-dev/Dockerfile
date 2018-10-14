FROM ubuntu:18.04

# Add docker-apps user
ARG HOST_USER_ID
ARG HOST_USER_GID
RUN groupadd -r -g $HOST_USER_GID docker-apps && useradd -r -u $HOST_USER_ID -g docker-apps -G audio,video docker-apps \
    && mkdir -p /home/docker-apps/godot-projects \
    && mkdir -p /home/docker-apps/Godot \
    && touch /home/docker-apps/Godot/._sc_ \
    && chown -R docker-apps:docker-apps /home/docker-apps

RUN apt-get update && apt-get install -y --no-install-recommends \
      wget \
      unzip \
      software-properties-common \
      libx11-6 \
      libxcursor-dev \
      libxinerama-dev \
      libxrandr-dev \
      libxi-dev \
      libasound2-dev \
      libpulse-dev \
      libgl-dev \
    && wget https://downloads.tuxfamily.org/godotengine/3.0.6/Godot_v3.0.6-stable_x11.64.zip \
    && unzip Godot_v3.0.6-stable_x11.64.zip \
    && rm Godot_v3.0.6-stable_x11.64.zip \
    && mv Godot_v3.0.6-stable_x11.64 /home/docker-apps/Godot/godot \
    && ln -s /home/docker-apps/Godot/godot /usr/bin/godot \
    && chown -R docker-apps:docker-apps /home/docker-apps/Godot \
    && apt-get remove -y \
        wget \
        unzip \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

#      libgles2-mesa-dev \
#      pulseaudio \
#      alsa-base \
#      alsa-utils \

# Run as non privileged user
USER docker-apps

ENTRYPOINT ["/usr/bin/godot"]
#ENTRYPOINT ["tail", "/dev/null", "-f"]
