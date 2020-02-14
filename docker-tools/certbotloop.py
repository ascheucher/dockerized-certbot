#!/usr/bin/python3

import os


def call_certbot(email, domains):
    from subprocess import call
    for domain in domains:
        params = ["/opt/certbot/venv/bin/certbot", "certonly", "--verbose", "--dns-route53",
                  "--dns-route53-propagation-seconds", "30", "--noninteractive", "--agree-tos",
                  f"--email=${email}", "-d", domain]
        call(params)


email = os.environ['email']
domains = os.environ['domains'].split(',')
call_certbot(email, domains)
