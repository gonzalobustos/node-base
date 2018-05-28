FROM node:8.11-alpine as builder

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package*.json /usr/src/app/
RUN npm install

COPY src /usr/src/app/src/
COPY tsconfig.json /usr/src/app
RUN npm run build:ts

RUN npm prune --production

FROM node:8.11-alpine

RUN mkdir -p /usr/src/app && \
    adduser -S app && \
    chown -R app /usr/src/app
WORKDIR /usr/src/app
USER app

COPY --from=builder /usr/src/app /usr/src/app/

CMD [ "node", "dist/app.js" ]
