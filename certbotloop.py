#!/usr/bin/python

def call_certbot(email, domains):
  from subprocess import call
  for domain in domains:
    params = ["certbot", "certonly", "--verbose", "--dns-route53", "--dns-route53-propagation-seconds", "30", "--noninteractive", "--agree-tos", "--email="+email, "-d", domain]
    call(params)

  
import os
email = os.environ['email']
domains = os.environ['domains'].split(',')
call_certbot(email, domains)
