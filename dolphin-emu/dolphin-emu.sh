PROJECT_DIR=`git rev-parse --show-toplevel`


docker build -t docker-apps:dolphin-emu "$PROJECT_DIR/dolphin-emu"

docker run --rm -d --net=host -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY --name=dolphin-emu docker-apps:dolphin-emu
