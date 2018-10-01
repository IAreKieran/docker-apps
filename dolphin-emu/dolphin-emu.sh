PROJECT_DIR=`git rev-parse --show-toplevel`
DOLPHIN_EMU_DIR="$PROJECT_DIR/dolphin-emu"

HOST_USER_ID=`id -u`
HOST_USER_GID=`id -g`

docker build \
  --build-arg "HOST_USER_ID=$HOST_USER_ID" \
  --build-arg "HOST_USER_GID=$HOST_USER_GID" \
  -t docker-apps:dolphin-emu $DOLPHIN_EMU_DIR

# To get basic files created on install for mount directories
DOLPHIN_EMU_DATA="$DOLPHIN_EMU_DIR/data"
if [ ! -d "$DOLPHIN_EMU_DATA" ]; then
  mkdir $DOLPHIN_EMU_DATA

  docker run --rm -d \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    --name=dolphin-emu docker-apps:dolphin-emu

  wait_cmd='while [ ! -d "/home/dolphin-emu/.local/share/dolphin-emu" ]; do echo "directory not ready"; sleep 1; done'
  docker exec dolphin-emu bash -c "$wait_cmd" # Wait for dolphin to finish making files on first startup
  docker cp dolphin-emu:/home/dolphin-emu/.local/share/dolphin-emu "$DOLPHIN_EMU_DATA/.local"
  docker cp dolphin-emu:/home/dolphin-emu/.config/dolphin-emu "$DOLPHIN_EMU_DATA/.config"
  docker kill dolphin-emu
  docker wait dolphin-emu
fi

docker run --rm -d \
  --hostname=dolphin-emu \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /home/kieran/Desktop/games:/home/dolphin-emu/games \
  -v "$DOLPHIN_EMU_DATA/.local:/home/dolphin-emu/.local/share/dolphin-emu" \
  -v "$DOLPHIN_EMU_DATA/.config:/home/dolphin-emu/.config/dolphin-emu" \
  -e DISPLAY=unix$DISPLAY \
  --name=dolphin-emu \
  docker-apps:dolphin-emu

