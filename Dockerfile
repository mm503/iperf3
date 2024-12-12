FROM alpine:3.21.0

# renovate: datasource=repology depName=alpine_3_21/iperf3 versioning=loose
ARG IPERF3_VERSION="3.17.1-r0"

LABEL org.opencontainers.image.title="iperf3-alpine"
LABEL org.opencontainers.image.description="iperf3 network performance measurement tool"
LABEL org.opencontainers.image.source="https://github.com/YOUR_REPO"
LABEL org.opencontainers.image.version="${IPERF3_VERSION}"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="YOUR_NAME <your.email@example.com>"

RUN apk --no-cache upgrade && \
  apk add --no-cache iperf3=${IPERF3_VERSION} && \
  adduser -D iperf

USER iperf
WORKDIR /home/iperf

EXPOSE 5201/tcp 5201/udp

ENTRYPOINT ["iperf3"]
