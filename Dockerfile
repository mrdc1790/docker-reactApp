FROM node:16-alpine AS base

# needs to specify which user that has permission to update container directories 'node' in this case
USER node
RUN mkdir -p /home/node/app
# the new directory path created is the new workdir
WORKDIR /home/node/app

# 'node' user owns this directory and all underlying directories
COPY --chown=node:node ./package.json ./
RUN npm install

COPY --chown=node:node ./ ./

RUN npm run build

## PHASE 2 of Docker build below

FROM nginx
COPY --from=base /home/node/app/build /usr/share/nginx/html
# no need for CMD because nginx automatically starts!