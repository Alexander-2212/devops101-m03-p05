APP        := demo
REGISTRY   ?= ghcr.io/alexander-2212
VERSION    ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
IMAGE_TAG  := $(REGISTRY)/$(APP):$(VERSION)

HOST_OS    := $(shell uname -s | tr '[:upper:]' '[:lower:]')
HOST_ARCH  := $(shell uname -m | sed -e 's/x86_64/amd64/' -e 's/aarch64/arm64/')

.PHONY: all test linux arm macos windows image push clean help

all: linux arm macos windows

test:
	go test ./...

linux:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o $(APP)-linux-amd64 .

arm:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o $(APP)-linux-arm64 .

macos:
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -o $(APP)-darwin-arm64 .

windows:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -o $(APP)-windows-amd64.exe .

image:
	docker build \
		--build-arg TARGETOS=$(HOST_OS) \
		--build-arg TARGETARCH=$(HOST_ARCH) \
		-t $(IMAGE_TAG) .

push:
	docker push $(IMAGE_TAG)

clean:
	rm -f $(APP)-*
	docker rmi $(IMAGE_TAG) || true

help:
	@echo "targets: linux arm macos windows image push clean test"
