FROM node:alpine3.12
# Create app directory
WORKDIR /usr/src/app
# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
RUN npm install

COPY . .
# If you are building your code for production
# RUN npm ci --only=production
# Bundle app source
EXPOSE 5501
# add non-root user for security (aqua scan will check this)
RUN addgroup -S local_group 
RUN adduser -S local_user -G local_group

USER local_user
CMD [ "node", "app.js" ]