VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
REGISTRY=vvitovt
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

