FROM quay.io/projectquay/golang:1.26 AS builder

WORKDIR /src
COPY go.mod ./
RUN go mod download
COPY . .

ARG TARGETOS=linux
ARG TARGETARCH=amd64

RUN CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build -o /out/demo .

FROM scratch
COPY --from=builder /out/demo /demo
EXPOSE 8080
ENTRYPOINT ["/demo"]
