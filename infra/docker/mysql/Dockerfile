# FROM mysql:8.4
FROM --platform=linux/amd64 mysql/mysql-server:5.7

ENV TZ=UTC

COPY ./infra/docker/mysql/*.cnf /etc/mysql/conf.d/
