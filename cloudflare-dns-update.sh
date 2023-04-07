#!/bin/bash

# Cloudflare API token and Website Zone ID
TOKEN="CLOUDFLARE-API-TOKEN-HERE"
ZONEID="CLOUDFLARE-ZONE-ID-HERE"

# DNS Record ID
DNSID="CLOUDFLARE-DNS-RECORD-ID-HERE"

# DNS record settings
TYPE="A"
NAME="@"
CONTENT=$(curl --silent --url https://api.ipify.org)
PROXIED="true"
TTL=1


###################################################################################################

# File settings
DIRNAME=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPTNAME=$(basename ${BASH_SOURCE})
FILENAME=${SCRIPTNAME%.*}
RESULTSFILE="${DIRNAME}/${FILENAME}_results.json"
DNSLISTFILE="${DIRNAME}/${FILENAME}_dnslist.json"

# Compile DNS record body data
BODYDATA="{ \"type\": \"${TYPE}\", \"name\": \"${NAME}\", \"content\": \"${CONTENT}\", \"proxied\": ${PROXIED}, \"ttl\":${TTL} }"

# Update or list DNS records
if [[ $1 != "list" ]];
then
  # Update DNS record
  REPSONSE=$(curl --silent --request PUT --url https://api.cloudflare.com/client/v4/zones/${ZONEID}/dns_records/${DNSID} --header "Content-Type: application/json" --header "Authorization: Bearer ${TOKEN}" --data "${BODYDATA}")
  echo ${REPSONSE} | tee ${RESULTSFILE}
else
  # List DNS rescords for zone
  REPSONSE=$(curl --silent --request GET --url https://api.cloudflare.com/client/v4/zones/${ZONEID}/dns_records --header "Content-Type: application/json" --header "Authorization: Bearer ${TOKEN}")
  echo ${REPSONSE} | tee ${DNSLISTFILE}
fi
