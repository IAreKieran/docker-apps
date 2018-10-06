FROM ubuntu:18.04

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common apt-utils locales

# Set locale to handle dolphin error
RUN sed -i -e 's/# en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_GB.UTF-8

ENV LANG en_GB.UTF-8

RUN apt-add-repository ppa:dolphin-emu/ppa \
	&& apt-get update && apt-get install -y --no-install-recommends dolphin-emu \
    	&& rm -rf /var/lib/apt/lists/*

# Add docker-apps user
ARG HOST_USER_ID
ARG HOST_USER_GID
RUN groupadd -r -g $HOST_USER_GID docker-apps && useradd -r -u $HOST_USER_ID -g docker-apps -G audio,video docker-apps \
    && mkdir -p /home/docker-apps/Downloads && chown -R docker-apps:docker-apps /home/docker-apps

# Run as non privileged user
USER docker-apps

ENTRYPOINT [ "/usr/games/dolphin-emu" ]
