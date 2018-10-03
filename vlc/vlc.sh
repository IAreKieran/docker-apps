APP='vlc'

# docker-apps settings
PROJECT_DIR=`git rev-parse --show-toplevel`
APP_DIR="$PROJECT_DIR/$APP"
APP_DATA="$APP_DIR/data"

HOST_USER_ID=`id -u`
HOST_USER_GID=`id -g`


# Mount points - Host
HOST_DATA_1="$APP_DATA/.config"
HOST_DATA_2="$APP_DATA/Downloads"


# Mount points - Container
CONTAINER_DATA_1="/home/docker-apps/.config/chromium"
CONTAINER_DATA_2="/home/docker-apps/Downloads"

# Build
docker build \
  --build-arg "HOST_USER_ID=$HOST_USER_ID" \
  --build-arg "HOST_USER_GID=$HOST_USER_GID" \
  -t docker-apps:$APP $APP_DIR

# If it's the first run, copy over initial user data files to host to be used as mounts
#if [ ! -d "$APP_DATA" ]; then
#  mkdir $APP_DATA
#
#  docker run --rm -d \
#    -v /tmp/.X11-unix:/tmp/.X11-unix \
#    -e DISPLAY=unix$DISPLAY \
#    --cap-add=SYS_ADMIN \
#    --name=$APP docker-apps:$APP

  # Wait for app to finish making files created on first startup, then copy to host
#  wait_cmd="while [ ! -d $CONTAINER_DATA_1 ] || [ ! -d $CONTAINER_DATA_2 ]; do sleep 0.2; done"
#  docker exec $APP bash -c "$wait_cmd"
#  docker cp $APP:$CONTAINER_DATA_1 $HOST_DATA_1
#  docker cp $APP:$CONTAINER_DATA_2 $HOST_DATA_2
#  docker stop $APP
#fi

docker run --rm -d \
  --hostname=$APP \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  --name=$APP \
  --device=/dev/dri \
  --device /dev/snd \
  docker-apps:$APP
