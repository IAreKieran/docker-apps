PROJECT_DIR=`git rev-parse --show-toplevel`
GUI_DIR="$PROJECT_DIR/GUI"

HOST_USER_ID=`id -u`
HOST_USER_GID=`id -g`

docker build \
  --build-arg "HOST_USER_ID=$HOST_USER_ID" \
  --build-arg "HOST_USER_GID=$HOST_USER_GID" \
  -t docker-apps:GUI $GUI_DIR


docker run --rm -d \
  --hostname=GUI \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY=unix$DISPLAY \
  --name=GUI \
  docker-apps:GUI

