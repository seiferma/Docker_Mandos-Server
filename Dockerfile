FROM alpine:latest AS downloader
ARG TARGETARCH
ARG S6_OVERLAY_VERSION
RUN apk add --no-cache xz gzip
RUN wget -O /s6-overlay-noarch.tar.xz https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz && \
    xz -dc < /s6-overlay-noarch.tar.xz > /s6-overlay-noarch.tar
RUN if [ "$TARGETARCH" == "arm64" ]; then export S6_ARCH=aarch64; elif [ "$TARGETARCH" == "amd64" ]; then export S6_ARCH=x86_64; elif [ "$TARGETARCH" == "arm/v6" ]; then export S6_ARCH=armhf; else exit 1; fi && \
    wget -O /s6-overlay-arch.tar.xz https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-$S6_ARCH.tar.xz && \
    xz -dc < /s6-overlay-arch.tar.xz > /s6-overlay-arch.tar && \
    wget -O /syslogd-overlay-noarch.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/syslogd-overlay-noarch.tar.xz && \
    xz -dc < /syslogd-overlay-noarch.tar.gz > syslogd-overlay-noarch.tar



FROM debian:stable-slim
ARG MANDOS_VERSION

# Install S6
RUN --mount=type=bind,from=downloader,source=/s6-overlay-noarch.tar,target=/s6-overlay-noarch.tar \
    --mount=type=bind,from=downloader,source=/s6-overlay-arch.tar,target=/s6-overlay-arch.tar \
    --mount=type=bind,from=downloader,source=/syslogd-overlay-noarch.tar,target=/syslogd-overlay-noarch.tar \
    tar -C / -xpf /s6-overlay-noarch.tar && \
    tar -C / -xpf /s6-overlay-arch.tar && \
    tar -C / -xpf /syslogd-overlay-noarch.tar
ENTRYPOINT ["/init"]
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# Install Mandos
ENV LOGLEVEL=INFO
EXPOSE 8080
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests mandos=${MANDOS_VERSION} && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    userdel _mandos
ADD s6-overlay /etc/s6-overlay
