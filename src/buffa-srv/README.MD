# buffa-srv
# what?
It serves the buffa app
# why?
Gotta start the share somewhere outside the computer
# how to run?
## node
in the root of the repo:
```
npm run start
```
## docker
with docker desktop running
```
docker run -d --name=buffa-srv \
    -p 3000:5501 \
    jizacal/buffa-srv:latest
```
# how to publish the image?
Run 
```
./scripts/docker_push.sh
```
