#!/bin/bash

# Cloudflare API credentials
TOKEN="[CLOUDFLARE-API-TOKEN-HERE]"

# DNS record settings
ZONEID="[CLOUDFLARE-ZONE-ID-HERE]"
DNSID="[CLOUDFLARE-DNS-RECORD-ID-HERE]"
TYPE="A"
NAME="@"
CONTENT=$(curl --silent --url https://api.ipify.org)
PROXIED="true"
TTL=1

# DNS record body JSON
BODYDATA="{ \"type\": \"${TYPE}\", \"name\": \"${NAME}\", \"content\": \"${CONTENT}\", \"proxied\": ${PROXIED}, \"ttl\":${TTL} }"


###################################################################################################

# File settings
DIRNAME=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
SCRIPTNAME=$(basename ${BASH_SOURCE})
FILENAME=${SCRIPTNAME%.*}
RESULTSFILE="${DIRNAME}/${FILENAME}_results.json"
DNSLISTFILE="${DIRNAME}/${FILENAME}_dnslist.json"
CONTENTFILE="${DIRNAME}/${FILENAME}_content.txt"

# Execute DNS update or list
if [[ $1 != "list" ]];
then
  # Update DNS record
  #OLDIP=$(cat ${CONTENTFILE})
  #if [[ ${CONTENT} != ${OLDIP} ]];
  #then
    echo Updating DNS record...
    curl --silent --request PUT --url https://api.cloudflare.com/client/v4/zones/${ZONEID}/dns_records/${DNSID} --header "Content-Type: application/json" --header "Authorization: Bearer ${TOKEN}" --data "${BODYDATA}" > ${RESULTSFILE}
    echo ${CONTENT} > ${CONTENTFILE}
    jq . ${RESULTSFILE}
  #else
  #  echo No need to update: Content is the same
  #fi
else
  # List DNS rescords
  echo Listing DNS records...
  curl --silent --request GET --url https://api.cloudflare.com/client/v4/zones/${ZONEID}/dns_records --header "Content-Type: application/json" --header "Authorization: Bearer ${TOKEN}" > ${DNSLISTFILE}
  jq . ${DNSLISTFILE}
fi
