FROM golang:1.17-alpine AS build
WORKDIR /go/src/Brijeshlakkad/distributedlogging
COPY . .
RUN CGO_ENABLED=0 go build -o /go/bin/distributedlogging ./cmd/distributedlogging

RUN GRPC_HEALTH_PROBE_VERSION=v0.3.0 && \
    wget -qO/go/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 
# Make it executable 
RUN chmod +x /go/bin/grpc_health_probe

FROM scratch
COPY --from=build /go/bin/distributedlogging /bin/distributedlogging

COPY --from=build /go/bin/grpc_health_probe /bin/grpc_health_probe

ENTRYPOINT ["/bin/distributedlogging"]