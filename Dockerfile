FROM golang:latest

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /app

ADD https://github.com/pbthorste/check_docker/archive/master.zip /app/

WORKDIR /app

RUN unzip master.zip

RUN go get github.com/fsouza/go-dockerclient

RUN go get github.com/newrelic/go_nagios

RUN go get github.com/shenwei356/util/bytesize

WORKDIR /app/check_docker-master

RUN go build check_docker.go

RUN ls -al
