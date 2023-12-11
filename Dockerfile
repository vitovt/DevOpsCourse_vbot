FROM quay.io/projectquay/golang:1.20 as builder
WORKDIR /go/src/app
copy . .
RUN make build

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/vbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./vbot", "start"]

