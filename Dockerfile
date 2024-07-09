FROM golang:1.16 as builder

COPY . /usr/src/rds_exporter

RUN cd /usr/src/rds_exporter

FROM        alpine:latest

COPY --from=builder /usr/src/rds_exporter/rds_exporter  /bin/
# COPY config.yml           /etc/rds_exporter/config.yml

FROM alpine:3.13

RUN apk add --no-cache ca-certificates && \
    update-ca-certificates

COPY rds_exporter /bin/

EXPOSE 9042
ENTRYPOINT [ "/bin/rds_exporter", "--config.file=/etc/rds_exporter/config.yml" ]
