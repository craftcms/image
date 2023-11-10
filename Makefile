IMAGE ?= craftcms/image
PHP_VERSION ?= 8.2
DEBIAN_VERSION ?= 12

build:
	docker build \
		--build-arg php_version=${PHP_VERSION} \
		--build-arg debian_version=${DEBIAN_VERSION} \
		--no-cache \
		--progress plain \
		--tag ${IMAGE}:${PHP_VERSION} .

dev: build
	docker run --rm -it ${IMAGE} /bin/bash

sizes:
	@echo "Size of ${IMAGE}:"
	@docker image inspect ${IMAGE}:latest --format '{{.Size}}' | numfmt --to=si

run: build
	docker-compose up --build

create-project:
	composer create-project craftcms/craft examples/craftcms/local