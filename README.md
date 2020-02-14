# What is Certbot

> [Certbot](https://certbot.eff.org) is an easy-to-use automatic client that fetches and deploys SSL/TLS certificates for your webserver. Certbot was developed by EFF and others as a client for [Let's Encrypt](https://letsencrypt.org) and was previously known as "the official Let’s Encrypt client" or "the Let’s Encrypt Python client." Certbot will also work with any other CAs that support the ACME protocol.

## Credits

This certbot docker image is inspired by [pslobo/dockerized-certbot](https://github.com/pslobo/dockerized-certbot) and [pierreprinetti/certbot](https://github.com/pierreprinetti/certbot).

The installation of certbot and the route53 plugin is from pslobo and the script to create the certificates from pierreprinetti.

## How to use this image

### replace user with your github user

do this in this files:

* Dockerfile
* docker-build.sh
* star.mfg.otaya.letsencrypt.update.sh

### build and tag the image

    ./docker-build.sh

### Create a docker volume to store the certificates

    docker volume create --name nginx-certs
    
### Set up an IAM user for editing your Rout53 Hosted zones

Create a IAM user to set up the DNS challenge.
This policy seems to do the job:

    {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Effect": "Allow",
              "Action": [
                  "route53:ListHostedZones",
                  "route53:GetChange"
              ],
              "Resource": [
                  "*"
              ]
          },
          {
              "Effect": "Allow",
              "Action": [
                  "route53:ChangeResourceRecordSets"
              ],
              "Resource": [
                  "arn:aws:route53:::hostedzone/YOUR-HOSTED-ZONE-ID"
              ]
          }
      ]
    }

### Set up a env file with the keys

Create the file aws-env with your IAMs user id and secret and other settings:

    AWS_ACCESS_KEY_ID="....."
    AWS_SECRET_ACCESS_KEY="......"

And a env file with the email and the domains to create certs for:

    DOMAINS="...."
    EMAIL="..."

### Start a Certbot instance with the script

    star.mfg.otaya.letsencrypt.update.sh

Now watch the bot to do the work :)

## Exposed Ports

- 80
- 443

## Exported Volumes

- `/etc/letsencrypt`
