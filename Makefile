IMAGE ?= cloud
PHP_VERSION ?= 8.0

build:
	docker build \
		--build-arg php_version=${PHP_VERSION} \
		--no-cache \
		--progress plain \
		--pull \
		--tag ${IMAGE} \
		php${PHP_VERSION}
dev: build
	docker run --rm -it ${IMAGE} /bin/bash
sizes:
	@echo "Size of ${IMAGE}:"
	@docker image inspect ${IMAGE}:latest --format '{{.Size}}' | numfmt --to=si
run:
	docker-compose up --build
