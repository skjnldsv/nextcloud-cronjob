#!/usr/bin/env bash
set -ex

if [[ -z "$NEXTCLOUD_CONTAINER_NAME" ]]; then
    echo "NEXTCLOUD_CONTAINER_NAME is a required variable"
    exit 1
fi

if [[ ! -z "$NEXTCLOUD_PROJECT_NAME" ]]; then
    containerName="${NEXTCLOUD_PROJECT_NAME}_"
else
    matchEnd=","
fi

containerName="${containerName}${NEXTCLOUD_CONTAINER_NAME}"

# Get the ID of the container so we can exec something in it later
export containerId=$(/find-container.sh "$containerName" "$matchEnd")

if [[ -z "$containerId" ]]; then
    echo "ERROR: Unable to find the Nextcloud container"
    exit 1
fi

echo "$containerId" > /tmp/containerId

echo "*/$NEXTCLOUD_CRON_MINUTE_INTERVAL * * * * /cron-tasks.sh $containerId" \
    > /var/spool/cron/crontabs/root

exec crond -f -l 0 -L /dev/stdout
