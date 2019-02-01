FROM golang:1.12-alpine3.9 AS build

RUN apk add --no-cache git build-base
RUN go get -u github.com/golang/dep/cmd/dep

WORKDIR /go/src/github.com/percona/rds_exporter

# Use docker cache when dependancies unchanged
COPY Gopkg.toml Gopkg.lock ./
RUN dep ensure -vendor-only

# Build the application
COPY . ./
COPY . /go/src/github.com/percona/rds_exporter
RUN make build


FROM alpine:3.9

RUN apk update && \
    apk add ca-certificates && \
    update-ca-certificates

COPY --from=build /go/src/github.com/percona/rds_exporter/rds_exporter /bin/

EXPOSE 9042
ENTRYPOINT [ "/bin/rds_exporter", "--config.file=/etc/rds_exporter/config.yml" ]
