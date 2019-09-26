.PHONY: build release
.DEFAULT_GOAL := build

DOCKER_IMAGE := shuzhang/faiss-docker
FAISS_VERSION := $(shell curl -s https://api.github.com/repos/facebookresearch/faiss/releases/latest | jq -r .tag_name | cut -c2-)

build:
	docker build \
		--build-arg IMAGE=ubuntu:18.04 \
		--build-arg FAISS_CPU_OR_GPU=cpu \
		--build-arg FAISS_VERSION=$(FAISS_VERSION) \
		--tag $(DOCKER_IMAGE):$(FAISS_VERSION)-cpu \
		--tag $(DOCKER_IMAGE) .

	docker build \
		--build-arg IMAGE=nvidia/cuda:10.1-runtime-ubuntu18.04 \
		--build-arg FAISS_CPU_OR_GPU=gpu \
		--build-arg FAISS_VERSION=$(FAISS_VERSION) \
		--tag $(DOCKER_IMAGE):$(FAISS_VERSION)-gpu .

release:
	docker push $(DOCKER_IMAGE)
	docker push $(DOCKER_IMAGE):$(FAISS_VERSION)-cpu
	docker push $(DOCKER_IMAGE):$(FAISS_VERSION)-gpu
