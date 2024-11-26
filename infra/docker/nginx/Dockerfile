FROM nginx:1.27 AS base

WORKDIR /workspace

ENV TZ=UTC

FROM base AS development

COPY ./infra/docker/nginx/default.development.conf /etc/nginx/conf.d/default.conf

FROM base AS deploy

COPY ./infra/docker/nginx/nginx.deploy.conf /etc/nginx/nginx.conf
COPY ./infra/docker/nginx/default.deploy.conf /etc/nginx/conf.d/default.conf
COPY ./src /workspace
