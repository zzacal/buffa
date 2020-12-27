#! /bin/bash
npm run build
echo 'Building buffa-srv:local'
docker build -t buffa-srv:local .
