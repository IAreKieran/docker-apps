docker build -t docker-apps:dolphin-emu /home/kieran/projects/third_party/docker-dolphin/vanilla

docker run --rm -d --net=host -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --name=dolphin-emu docker-apps:dolphin-emu
