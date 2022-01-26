IMAGE ?= cloud-image

build:
	docker build --build-arg php_version=8.1 --no-cache --progress plain --pull -t ${IMAGE} .
dev: build
	docker run --rm -it ${IMAGE} /bin/bash
sizes:
	@echo "Size of ${IMAGE}:"
	@docker image inspect ${IMAGE}:latest --format '{{.Size}}' | numfmt --to=si
run:
	docker-compose up --build
