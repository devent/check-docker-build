REPOSITORY := erwinnttdata
NAME := check-docker
VERSION ?= 1.0-001
BUILD_PATH=/app/check_docker-master

build: _build ##@targets Builds the application.
	set -x \
	&& id=$$(docker create "$(REPOSITORY)/$(NAME):$(VERSION)") \
	&& docker cp $$id:$(BUILD_PATH)/check_docker - > check_docker \
	&& docker rm -v $$id \
	&& tar -xf check_docker \
	&& shasum check_docker > check_docker.sha
.PHONY: build

rebuild: _rebuild ##@targets Deletes the build and builds new.
.PHONY: rebuild

clean: _clean ##@targets Removes the build.
.PHONY: clean

test:
	docker run -d --name test-run-busybox busybox sleep 60
	docker run -d --name test-stop-busybox busybox
	./check_docker \
	-base-url="localhost:2375" \
	-container-name="test-run-busybox" \
	-warn-data-space=100 \
	-crit-data-space=100 \
	-warn-meta-space=100 \
	-crit-meta-space=100 \
	-image-id=""; true
	./check_docker \
	-base-url="localhost:2375" \
	-container-name="test-stop-busybox" \
	-warn-data-space=100 \
	-crit-data-space=100 \
	-warn-meta-space=100 \
	-crit-meta-space=100 \
	-image-id=""; true
	docker rm -f test-run-busybox
	docker rm -f test-stop-busybox
.PHONY: test

include Makefile.help
include Makefile.functions
include Makefile.image
