PROJECT_DIR=`git rev-parse --show-toplevel`


docker build -t docker-apps:dolphin-emu "$PROJECT_DIR/dolphin-emu"

# To get basic files for mount directo
#docker run --rm -d --net=host -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/kieran/Desktop/games:/home/dolphin-emu/games -e DISPLAY=unix$DISPLAY --name=dolphin-emu docker-apps:dolphin-emu
#docker cp dolphin-emu:/home/dolphin-emu/.local/share/dolphin-emu /home/kieran/projects/docker-apps/dolphin-emu/data

docker run --rm -d --net=host -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/kieran/Desktop/games:/home/dolphin-emu/games -v /home/kieran/projects/docker-apps/dolphin-emu/data:/home/dolphin-emu/.local/share/dolphin-emu -e DISPLAY=unix$DISPLAY --name=dolphin-emu docker-apps:dolphin-emu

