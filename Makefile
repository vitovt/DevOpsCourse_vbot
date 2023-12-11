VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
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

clean:
	rm -rf vbot
