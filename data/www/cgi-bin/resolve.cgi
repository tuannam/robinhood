#!/usr/bin/env bash

query=${QUERY_STRING}

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }
url=$(urldecode ${query})

echo 'Content-Type: application/json'

response=$(curl "$url" \
  -H 'accept-language: en-AU,en;q=0.9,vi-VN;q=0.8,vi;q=0.7,en-GB;q=0.6,en-US;q=0.5' \
  -H 'referer: https://ghienxemphim.net/' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
  --compressed
  )
  
resolved=$(echo "$response" | grep "controls src" | sed -e 's/.*controls src=\"//g' | sed -e 's/\".*//')
echo -e "\n{\"url\": \"${resolved}\"}"