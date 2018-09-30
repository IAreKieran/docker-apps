PROJECT_DIR=`git rev-parse --show-toplevel`


docker build -t docker-apps:dolphin-emu "$PROJECT_DIR/dolphin-emu"

# To get basic files created on install for mount directories
data_dir="$PROJECT_DIR/dolphin-emu/data"
if [ ! -d "$data_dir" ]; then
  mkdir /home/kieran/projects/docker-apps/dolphin-emu/data

  docker run --rm -d \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    --name=dolphin-emu docker-apps:dolphin-emu

  docker cp dolphin-emu:/home/dolphin-emu/.local/share/dolphin-emu /home/kieran/projects/docker-apps/dolphin-emu/data/.local
  docker cp dolphin-emu:/home/dolphin-emu/.config/dolphin-emu /home/kieran/projects/docker-apps/dolphin-emu/data/.config
  docker kill dolphin-emu
fi

docker run --rm -d \
  --net=host \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /home/kieran/Desktop/games:/home/dolphin-emu/games \
  -v /home/kieran/projects/docker-apps/dolphin-emu/data/.local:/home/dolphin-emu/.local/share/dolphin-emu \
  -v /home/kieran/projects/docker-apps/dolphin-emu/data/.config:/home/dolphin-emu/.config/dolphin-emu \
  -e DISPLAY=unix$DISPLAY \
  --name=dolphin-emu \
  docker-apps:dolphin-emu

