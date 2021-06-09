FROM node:12-alpine

LABEL "com.github.actions.name"="Publish monorepo to npm"
LABEL "com.github.actions.description"="Automatically publish multiple packages to npm"
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="red"

RUN apk add --no-cache git openssl

COPY . /tmp/src/

RUN yarn global add --production true "file:/tmp/src" && rm -rf /tmp/src

ENTRYPOINT [ "npm-publish-monorepo-action" ]
