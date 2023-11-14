IMAGE ?= craftcms/image
PHP_VERSION ?= 8.2
DEBIAN_VERSION ?= 12

build:
	docker build \
		--build-arg php_version=${PHP_VERSION} \
		--build-arg debian_version=${DEBIAN_VERSION} \
		--progress plain \
		--tag ${IMAGE}:${PHP_VERSION} .

dev: build
	docker run --rm -it ${IMAGE}:${PHP_VERSION} /bin/bash
php-fpm: build
	docker run --rm -it ${IMAGE}:${PHP_VERSION}

sizes:
	@echo "Size of ${IMAGE}:"
	@docker image inspect ${IMAGE}:latest --format '{{.Size}}' | numfmt --to=si

run: build
	docker-compose up --build

create-project:
	composer create-project craftcms/craft examples/craftcms/local