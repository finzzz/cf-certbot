#!/bin/bash

REPO_PATH=$(dirname "$(readlink -f "$0")")
API_KEY=$(grep API_KEY "$REPO_PATH"/creds.txt | cut -d '"' -f 2)

if [ -f /tmp/CERTBOT_"$CERTBOT_DOMAIN"/ZONE_ID ]; then
        ZONE_ID=$(cat /tmp/CERTBOT_"$CERTBOT_DOMAIN"/ZONE_ID)
        rm -f /tmp/CERTBOT_"$CERTBOT_DOMAIN"/ZONE_ID
fi

if [ -f /tmp/CERTBOT_"$CERTBOT_DOMAIN"/RECORD_ID ]; then
        RECORD_IDS=$(cat /tmp/CERTBOT_"$CERTBOT_DOMAIN"/RECORD_ID)
        rm -f /tmp/CERTBOT_"$CERTBOT_DOMAIN"/RECORD_ID
fi

# Remove the challenge TXT record from the zone
if [ -n "${ZONE_ID}" ]; then
    if [ -n "${RECORD_IDS}" ]; then
        for RECORD_ID in $RECORD_IDS
        do curl -s -X DELETE "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
                -H "Authorization: Bearer $API_KEY" \
                -H "Content-Type: application/json"
        done
    fi
fi
