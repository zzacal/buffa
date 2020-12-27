#! /bin/bash
./scripts/docker_build_image.sh

echo "Stopping buffa-srv"
docker stop buffa-srv || true &&
docker container rm buffa-srv || true &&

echo "Running buffa-srv"
docker run -d --name=buffa-srv \
    -p 5501:5501 \
    buffa-srv:local
