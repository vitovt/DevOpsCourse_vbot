FROM quay.io/projectquay/golang:1.20 as builder
WORKDIR /go/src/app
copy . .
ARG TARGETARCH
ARG TARGETOS
RUN if [ -n "$TARGETOS" ] || [ -n "$TARGETARCH" ]; then \
        make build TARGETOS=$TARGETOS TARGETARCH=$TARGETARCH; \
    else \
        make build; \
    fi

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/vbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./vbot", "start"]

