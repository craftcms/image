IMAGE ?= craftcms/base
PHP_VERSION ?= 8.1
FEDORA_VERSION ?= 37

build-base:
	docker build \
		--build-arg php_version=${PHP_VERSION} \
		--build-arg fedora_version=${FEDORA_VERSION} \
		--no-cache \
		--progress plain \
		--pull \
		--tag ${IMAGE}:${PHP_VERSION} base

dev: build-base
	docker run --rm -it ${IMAGE} /bin/bash

sizes:
	@echo "Size of ${IMAGE}:"
	@docker image inspect ${IMAGE}:latest --format '{{.Size}}' | numfmt --to=si

run: build-base
	docker-compose up --build

create-project:
	composer create-project craftcms/craft local