#! /bin/bash
./scripts/docker_build_image.sh &&
./scripts/docker_tag.sh &&
echo 'pushing docker.io/jizacal/buffa-srv:latest' &&
docker push docker.io/jizacal/buffa-srv:latest
