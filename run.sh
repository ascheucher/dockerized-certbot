#!/bin/sh

if [ -z ${renew+x} ]
then
  if [ -z ${email+x} ]
  then
    echo "Fatal: administrator email address must be specified with the environment variable named 'email'"
    exit 1
  fi
  if [ -z ${domains+x} ]
  then
    echo "Fatal: domains must be specified with the environment variable named 'domains'"
    exit 1
  fi
  #if [ -z ${agree_tos+x} ]; then echo "Fatal: agree to the TOS setting the environment variable named 'agree_tos'"; exit 1; fi
  #if [ -z ${distinct+x} ]; then

  certbotloop.py

  #else
    #IFS=',' read -ra ADDR <<< "$domains"
    #for domain in "${ADDR[@]}"; do
    #    certbot certonly --verbose --dns-routeeee53 --dns-route53-propagation-seconds 30 --noninteractive --standalone --agree-tos --email="${email}" -d "${domain}" $@;
    #done
  #fi;
else
  certbot renew
fi
