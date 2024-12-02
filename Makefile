IMAGE ?= craftcms/image
PHP_VERSION ?= 8.4
TAG ?= ${PHP_VERSION}

build:
	docker build \
		--build-arg php_version=${PHP_VERSION} \
		--progress plain \
		--tag ${IMAGE}:${TAG} .

dev: build
	docker run --rm -it --entrypoint /bin/bash ${IMAGE}:${PHP_VERSION}
php-fpm: build
	docker run --rm -it ${IMAGE}:${PHP_VERSION}
version:
	@docker run --rm --entrypoint sh ${IMAGE}:${PHP_VERSION} -c 'php -v | head -n 1 | cut -d " " -f 2'

sizes:
	@echo "Size of ${IMAGE}:"
	@docker image inspect ${IMAGE}:latest --format '{{.Size}}' | numfmt --to=si

run: build
	docker-compose up --build

create-project:
	composer create-project craftcms/craft examples/craftcms/local
