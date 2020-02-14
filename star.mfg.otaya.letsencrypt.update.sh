#!/bin/bash

set -e

systemctl stop docker-compose-ephemeral@nginx-reverse-proxy.service

. /home/andi/docker-server-env/nginx-reverse-proxy-certbot/aws-env
. /home/andi/docker-server-env/nginx-reverse-proxy-certbot/domains-env

docker run \
  -v nginx-certs:/etc/letsencrypt \
  -e http_proxy=$http_proxy \
  -e domains="${DOMAINS}" \
  -e email="${EMAIL}" \
  -e AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID" \
  -e AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY" \
  -p 10.0.0.27:80:80 \
  -p 10.0.0.27:443:443 \
  --rm ascheucher/dockerized-certbot:latest

systemctl start docker-compose-ephemeral@nginx-reverse-proxy.service
