VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY=eu.gcr.io/devopscourse-407819
APP=vbot
ifndef TARGETOS
  TARGETOS=linux#linux darwin windows
endif
ifndef TARGETARCH
  TARGETARCH := $(shell dpkg --print-architecture 2>/dev/null || rpm --eval %{_arch} 2>/dev/null || echo "unknown")
  TARGETARCH := $(if $(filter unknown,$(TARGETARCH)),$(shell uname -m),$(TARGETARCH))
  TARGETARCH := $(if $(filter x86_64,$(TARGETARCH)),amd64,$(TARGETARCH))
  TARGETARCH := $(if $(filter unknown,$(TARGETARCH)),arm64,$(TARGETARCH)) #default
endif

help:
	@echo "Makes vbot - teleGO based telegram bot"
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "Main targets:"
	@echo "  build       : Build the application"
	@echo "  image       : Build Docker image"
	@echo "  push        : Push Docker image to registry"
	@echo "  clean       : Remove build artifacts"
	@echo ""
	@echo "Helpers:"
	@echo "  format      : Format the source code"
	@echo "  lint        : Lint the source code"
	@echo "  test        : Run tests"
	@echo "  get         : Download and install packages"
	@echo ""
	@echo "Environment Variables:"
	@echo "  TARGETOS    : Target operating system (default: linux, options: linux darwin windows openbsd solarisi)"
	@echo "  TARGETARCH  : Target architecture (default: [try autodetect], options: amd64 arm arm64 mips mips64)"
	@echo ""
	@echo "Hint: You can set the TARGETOS and TARGETARCH variables when running make, e.g.,"
	@echo "      make build TARGETOS=linux TARGETARCH=amd64"
	@echo "list of supported GOOS/GOARCH pair see here: https://gist.github.com/asukakenji/f15ba7e588ac42795f421b48b8aede63#file-0-go-os-arch-md"

format:
	gofmt -s -w ./

lint:
	golint

test:
	go test -v

get:
	go get

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o vbot -ldflags "-X="vbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}  --build-arg TARGETARCH=${TARGETARCH} --build-arg TARGETOS=${TARGETOS}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

clean:
	rm -rf kbot
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

