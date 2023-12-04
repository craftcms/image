IMAGE ?= craftcms/image
PHP_VERSION ?= 8.2
UBUNTU_VERSION ?= 22.04
TAG ?= ${PHP_VERSION}

build:
	docker build \
		--build-arg php_version=${PHP_VERSION} \
		--build-arg ubuntu_version=${UBUNTU_VERSION} \
		--progress plain \
		--tag ${IMAGE}:${TAG} .

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

shell:
	docker run --rm -it ubuntu:${UBUNTU_VERSION} /bin/bash