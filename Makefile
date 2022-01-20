IMAGE ?= cloud-image

build:
	docker build --pull -t ${IMAGE} .
sizes:
	docker image ls | grep ${IMAGE}
run: build
	docker-compose up --build
