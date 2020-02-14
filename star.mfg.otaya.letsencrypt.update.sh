#!/bin/bash

set -e

# stop the reverse proxy nginx docker container
if [[ "xdocker-host-01" -eq "x$HOSTNAME" ]]
then
  systemctl stop docker-compose-ephemeral@nginx-reverse-proxy.service
fi

# load the environment
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
. ${DIR}/aws-env
. ${DIR}/domains-env

# update the certificates
docker run \
  -v nginx-certs:/etc/letsencrypt \
  -e http_proxy=$http_proxy \
  -e domains="${DOMAINS}" \
  -e email="${EMAIL}" \
  -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
  -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
  --rm ascheucher/dockerized-certbot:latest

# start the reverse proxy nginx docker container again
if [[ "xdocker-host-01" -eq "x$HOSTNAME" ]]
then
  systemctl start docker-compose-ephemeral@nginx-reverse-proxy.service
fi
