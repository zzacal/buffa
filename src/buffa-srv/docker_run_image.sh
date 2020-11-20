#! /bin/bash
./docker_build_image.sh

echo "Stopping buffa-srv"
docker stop buffa-srv || true &&
docker container rm buffa-srv || true &&

echo "Running buffa-srv"
docker run -d --name=buffa-srv \
    -p 3000:5501 \
    buffa-srv:local
