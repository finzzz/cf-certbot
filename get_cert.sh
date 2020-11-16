#! /bin/bash

REPO_PATH=$(dirname "$(readlink -f "$0")")
DOMAIN_NAME=$(grep DOMAIN_NAME "$REPO_PATH"/creds.txt | cut -d '"' -f 2)
CONTACT=$(grep CONTACT "$REPO_PATH"/creds.txt | cut -d '"' -f 2)

certbot certonly -n --agree-tos --manual \
                 --manual-public-ip-logging-ok \
                 --no-eff-email --preferred-challenges=dns \
                 --manual-auth-hook "$REPO_PATH"/auth.sh \
                 --manual-cleanup-hook "$REPO_PATH"/clean.sh \
                 -m "$CONTACT" -d "$DOMAIN_NAME",*."$DOMAIN_NAME"

# for haproxy
#cat /etc/letsencrypt/live/"$DOMAIN_NAME"/{fullchain.pem,privkey.pem} > /etc/haproxy/fullcert.pem