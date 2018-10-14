APP='godot-dev'

# docker-apps settings
PROJECT_DIR=`git rev-parse --show-toplevel`
APP_DIR="$PROJECT_DIR/$APP"
APP_DATA="$APP_DIR/data"

HOST_USER_ID=`id -u`
HOST_USER_GID=`id -g`


# Mount points - Host
HOST_DATA_1="/home/kieran/projects/chef_sloth"
HOST_DATA_2="$APP_DATA/editor_data"


# Mount points - Container
CONTAINER_DATA_1="/home/docker-apps/godot-projects/chef_sloth"
CONTAINER_DATA_2="/home/docker-apps/Godot/editor_data"

# Devices
HOST_INPUT_1="/dev/snd"   # Sound
HOST_INPUT_2="/var/run/dbus"   # for pulseaudio
HOST_INPUT_3="/dev/dri"   # GPU?
CONTAINER_INPUT_1=$HOST_INPUT_1
CONTAINER_INPUT_2=$HOST_INPUT_2
CONTAINER_INPUT_3=$HOST_INPUT_3

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
#    --name=$APP docker-apps:$APP
#
#  # Wait for app to finish making files created on first startup, then copy to host
#  wait_cmd="while [ ! -d $CONTAINER_DATA_2 ]; do sleep 0.2; done"
#  docker exec $APP bash -c "$wait_cmd"
#  docker exec -u 0 $APP chown -R docker-apps:docker-apps $CONTAINER_DATA_2 # Editor data is made as root for some reason, will fix later
#  docker cp $APP:$CONTAINER_DATA_2 $HOST_DATA_2
#  docker stop $APP
#fi

docker run --rm -d \
  --hostname=$APP \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  -v "$HOST_DATA_1:$CONTAINER_DATA_1" \
  -v "$HOST_DATA_2:$CONTAINER_DATA_2" \
  -v "$HOST_INPUT_1:$CONTAINER_INPUT_1" \
  -v "$HOST_INPUT_2:$CONTAINER_INPUT_2" \
  --name=$APP \
  docker-apps:$APP

# Crashes unless run from exec for some reason :(
bash -c "docker exec $APP godot && docker stop $APP" &>/dev/null &
