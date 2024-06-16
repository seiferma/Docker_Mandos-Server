FROM debian:stable-slim

ARG VERSION

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
CMD ["default"]
ADD entrypoint.sh /entrypoint.sh

RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests mandos=${VERSION} && \
    apt clean autoclean && \
    apt autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
