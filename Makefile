IMAGE ?= cloud-image

build:
	docker build --pull -t ${IMAGE} .
sizes:
	docker image ls | grep ${IMAGE}
