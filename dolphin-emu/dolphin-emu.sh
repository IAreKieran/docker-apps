# User set variables
HOST_GAMES_DIR="/home/kieran/Desktop/games"

# App name
APP='dolphin-emu'

# docker-apps settings
PROJECT_DIR=`git rev-parse --show-toplevel`
APP_DIR="$PROJECT_DIR/$APP"
APP_DATA="$APP_DIR/data"

HOST_USER_ID=`id -u`
HOST_USER_GID=`id -g`

# Mount points - Host
HOST_DATA_1="$APP_DATA/.local"
HOST_DATA_2="$APP_DATA/.config"

# Mount points - Container
CONTAINER_GAMES_DIR="/home/docker-apps/games"
CONTAINER_DATA_1="/home/docker-apps/.local/share/dolphin-emu"
CONTAINER_DATA_2="/home/docker-apps/.config/dolphin-emu"

# Build
docker build \
  --build-arg "HOST_USER_ID=$HOST_USER_ID" \
  --build-arg "HOST_USER_GID=$HOST_USER_GID" \
  -t docker-apps:$APP $APP_DIR

# If it's the first run, copy over initial user data files to host to be used as mounts
if [ ! -d "$APP_DATA" ]; then
  mkdir $APP_DATA

  docker run --rm -d \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=unix$DISPLAY \
    --name=$APP docker-apps:$APP

  # Wait for dolphin to finish making files created on first startup, then copy to host
  wait_cmd="while [ ! -d $CONTAINER_DATA_1 ] || [ ! -d $CONTAINER_DATA_2 ]; do sleep 0.2; done"
  docker exec $APP bash -c "$wait_cmd"
  docker cp $APP:$CONTAINER_DATA_1 $HOST_DATA_1
  docker cp $APP:$CONTAINER_DATA_2 $HOST_DATA_2
  docker kill $APP
  docker wait $APP
fi

docker run --rm -d \
  --hostname=$APP \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v "$HOST_GAMES_DIR:$CONTAINER_GAMES_DIR" \
  -v "$HOST_DATA_1:$CONTAINER_DATA_1" \
  -v "$HOST_DATA_2:$CONTAINER_DATA_2" \
  -e DISPLAY=unix$DISPLAY \
  --name=$APP \
  docker-apps:$APP

