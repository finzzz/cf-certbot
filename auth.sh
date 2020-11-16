#!/bin/bash

REPO_PATH=$(dirname "$(readlink -f "$0")")
API_KEY=$(grep API_KEY "$REPO_PATH"/creds.txt | cut -d '"' -f 2)
EMAIL=$(grep EMAIL "$REPO_PATH"/creds.txt | cut -d '"' -f 2)
ZONE_ID=$(grep ZONE_ID "$REPO_PATH"/creds.txt | cut -d '"' -f 2)

# Create TXT record
CREATE_DOMAIN="_acme-challenge.$CERTBOT_DOMAIN"
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records" \
     -H     "X-Auth-Email: $EMAIL" \
     -H     "X-Auth-Key: $API_KEY" \
     -H     "Content-Type: application/json" \
     --data '{"type":"TXT","name":"'"$CREATE_DOMAIN"'","content":"'"$CERTBOT_VALIDATION"'","ttl":120}'

# Get Record ID
RECORD_ID=$(curl -s "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?type=TXT&name=$CREATE_DOMAIN" \
                -H "Content-Type:application/json" \
                -H "X-Auth-Email: $EMAIL" \
                -H "X-Auth-Key: $API_KEY" \
                | grep -oE "\"id\":\"\w+\"" \
                | cut -d '"' -f 4)

# Save info for cleanup
if [ ! -d /tmp/CERTBOT_"$CERTBOT_DOMAIN" ];then
        mkdir -m 0700 /tmp/CERTBOT_"$CERTBOT_DOMAIN"
fi

echo "$ZONE_ID" > /tmp/CERTBOT_"$CERTBOT_DOMAIN"/ZONE_ID
echo "$RECORD_ID" > /tmp/CERTBOT_"$CERTBOT_DOMAIN"/RECORD_ID
                                                        
# Sleep to make sure the change has time to propagate over to DNS
sleep 15