#!/bin/bash

set -e

trap ctrl_c INT

function ctrl_c() {
    echo "** exiting"
    exit 2
}

#--------------------------#
# Docker in docker daemon  #
#--------------------------#
if [[ "$DOCKERD_RUN" == "true" ]]; then
    if [[ "$DOCKERD_STREAM_LOGS" == "false" ]]; then
        # log only the last message to a file
        dockerd-entrypoint.sh &> /var/log/docker.log &
    else
        dockerd-entrypoint.sh &
    fi

    x=0
    while [[ "$x" -lt "$DOCKERD_RETRY" ]] && [[ ! $(docker ps) ]]; do
        x=$((x+1))
        sleep .5
    done

    if ! docker ps &>/dev/null; then
        exit 1
    fi
fi

#--------------#
#  SSH Client  #
#--------------#
base64_decode() {
  echo "$1" | tr -d '\n' | base64 -d
}

mkdir -p ~/.ssh && chmod 700 ~/.ssh

if [[ ! -z "$SSH_PRIVATE_KEY" ]]; then
    echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa && \
    chmod 600 ~/.ssh/id_rsa
    unset SSH_PRIVATE_KEY
fi

if [[ ! -z "$SSH_PRIVATE_KEY_B64" ]]; then
    base64_decode "$SSH_PRIVATE_KEY_B64" > ~/.ssh/id_dsa && \
    chmod 600 ~/.ssh/id_dsa
    unset SSH_PRIVATE_KEY_B64
fi

exec "$@"