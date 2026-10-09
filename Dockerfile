FROM alpine:3.24.2

# Managed by .github/workflows/update-iperf3.yml (reads alpine edge/main APKINDEX directly)
ARG IPERF3_VERSION="3.22-r0"
ARG IMAGE_VERSION="0"

LABEL org.opencontainers.image.title="mm503/iperf3"
LABEL org.opencontainers.image.description="iperf3 network performance measurement tool"
LABEL org.opencontainers.image.source="https://github.com/mm503/iperf3"
LABEL org.opencontainers.app.version="${IPERF3_VERSION}"
LABEL org.opencontainers.image.version="${IMAGE_VERSION}"
LABEL org.opencontainers.image.licenses="MIT"
LABEL maintainer="MM503 <jostles-felts-0f@icloud.com>"

RUN apk --no-cache upgrade && \
  apk add --no-cache -X https://dl-cdn.alpinelinux.org/alpine/edge/main iperf3=${IPERF3_VERSION} && \
  adduser -D iperf

USER iperf
WORKDIR /home/iperf

EXPOSE 5201/tcp 5201/udp

ENTRYPOINT ["iperf3"]
