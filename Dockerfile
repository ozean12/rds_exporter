FROM golang:1.16-alpine3.13 AS builder

RUN apk add --no-cache git build-base

FROM alpine:3.13

RUN apk add --no-cache ca-certificates && \
    update-ca-certificates

COPY rds_exporter /bin/

EXPOSE 9042
ENTRYPOINT [ "/bin/rds_exporter", "--config.file=/etc/rds_exporter/config.yml" ]
