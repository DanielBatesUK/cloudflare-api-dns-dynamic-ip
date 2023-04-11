#!/bin/bash

# Cloudflare API token and Website Zone ID
TOKEN="CLOUDFLARE-API-TOKEN-HERE"
ZONEID="CLOUDFLARE-ZONE-ID-HERE"

# DNS Record ID
DNSID="CLOUDFLARE-DNS-RECORD-ID-HERE"

# DNS record settings
NAME="@"
PROXIED="true"
TTL=1


###################################################################################################

# File settings
DIRNAME=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPTNAME=$(basename ${BASH_SOURCE})
FILENAME=${SCRIPTNAME%.*}
RESULTSFILE="${DIRNAME}/${FILENAME}_results.json"
DNSFILE="${DIRNAME}/${FILENAME}_dns.json"

# Update or get DNS records
if [[ $1 != "--get-dns" ]];
then
  # Update DNS record
  TYPE="A"
  CONTENT=$(curl --silent --url https://api.ipify.org)
  BODYDATA="{ \"type\": \"${TYPE}\", \"name\": \"${NAME}\", \"content\": \"${CONTENT}\", \"proxied\": ${PROXIED}, \"ttl\":${TTL} }"
  REPSONSE=$(curl --silent --request PUT --url https://api.cloudflare.com/client/v4/zones/${ZONEID}/dns_records/${DNSID} --header "Content-Type: application/json" --header "Authorization: Bearer ${TOKEN}" --data "${BODYDATA}")
  echo ${REPSONSE} | tee ${RESULTSFILE}
else
  # Get DNS rescords for zone
  REPSONSE=$(curl --silent --request GET --url https://api.cloudflare.com/client/v4/zones/${ZONEID}/dns_records --header "Content-Type: application/json" --header "Authorization: Bearer ${TOKEN}")
  echo ${REPSONSE} | tee ${DNSFILE}
fi
