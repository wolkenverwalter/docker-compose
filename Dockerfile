ARG DOCKER_VERSION=20.10.14
ARG COMPOSE_VERSION=1.29.2

FROM docker:${DOCKER_VERSION}

MAINTAINER Antony Goetzschel <mail@ago.dev>

RUN apk update

RUN apk upgrade

RUN apk add --no-cache \
		libseccomp \
		ca-certificates \
		python3-dev \
		py3-pip \
		libffi-dev \
		openssl-dev \
		gcc \
		libc-dev \
		make \
		bash \
		git \
		curl

RUN pip3 install "docker-compose${COMPOSE_VERSION:+==}${COMPOSE_VERSION}"

RUN pip3 list

RUN addgroup -S -g 1000 docker && adduser -S -G docker -u 1000 docker

RUN docker --version && \
    docker-compose --version && \
    git --version

## docker-entrypoint.sh from Docker-Docker-Image
##  https://github.com/docker-library/docker/tree/6001c15038b05149a83dcc17e1bbeedc92979f6d
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["sh"]

LABEL org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.vcs-type="Git" \
      org.label-schema.vcs-url="https://github.com/dev-ago/docker-network-utils"
