FROM ubuntu:18.04

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common apt-utils

RUN apt-add-repository ppa:dolphin-emu/ppa \
	&& apt-get update && apt-get install -y --no-install-recommends dolphin-emu \
    	&& rm -rf /var/lib/apt/lists/*

# Add dolphin-emu user
RUN groupadd -r dolphin-emu && useradd -r -g dolphin-emu -G audio,video dolphin-emu \
    && mkdir -p /home/dolphin-emu/Downloads && chown -R dolphin-emu:dolphin-emu /home/dolphin-emu

# Run dolphin-emu as non privileged user
USER dolphin-emu

ENTRYPOINT [ "/usr/games/dolphin-emu" ]
#ENTRYPOINT ["tail", "/dev/null", "-f"]
