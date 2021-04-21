FROM golang:1.16-alpine3.13 AS build

RUN apk add --no-cache git build-base

# Build the application
WORKDIR /go/src/github.com/percona/rds_exporter
COPY . ./
ENV GO111MODULE=on
RUN go mod init github.com/percona/rds_exporter && go mod tidy && go mod vendor
RUN make build || (go mod vendor && make build)


FROM alpine:3.13

RUN apk add --no-cache ca-certificates && \
    update-ca-certificates

COPY --from=build /go/src/github.com/percona/rds_exporter/rds_exporter /bin/

EXPOSE 9042
ENTRYPOINT [ "/bin/rds_exporter", "--config.file=/etc/rds_exporter/config.yml" ]
