FROM alpine

RUN apk add --no-cache docker bash

ENV NEXTCLOUD_CONTAINER_NAME=
ENV NEXTCLOUD_PROJECT_NAME=
ENV NEXTCLOUD_CRON_MINUTE_INTERVAL=15

COPY scripts/*.sh /
COPY scripts/cron-scripts /cron-scripts

ENTRYPOINT ["/entrypoint.sh"]

HEALTHCHECK --timeout=5s \
    CMD ["/healthcheck.sh"]