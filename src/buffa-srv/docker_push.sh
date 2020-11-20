#! /bin/bash
./docker_build_image.sh &&
./docker_tag.sh &&
echo 'pushing docker.io/jizacal/buffa-srv:latest' &&
docker push docker.io/jizacal/buffa-srv:latest