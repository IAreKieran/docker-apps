APP='chrome'

PROJECT_DIR=`git rev-parse --show-toplevel`
APP_DIR="$PROJECT_DIR/$APP"

HOST_USER_ID=`id -u`
HOST_USER_GID=`id -g`

docker build \
  --build-arg "HOST_USER_ID=$HOST_USER_ID" \
  --build-arg "HOST_USER_GID=$HOST_USER_GID" \
  -t docker-apps:$APP $APP_DIR


docker run --rm -d \
  --hostname=$APP \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  --name=$APP \
  docker-apps:$APP
