#!/usr/bin/env bash

query=${QUERY_STRING}

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }
url=$(urldecode ${query})

echo 'Content-Type: application/json'

if [[ "$url" == *"ok.ru"* ]]; then
  response=$(curl "$url" \
  -H 'authority: ok.ru' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'accept-language: en-AU,en;q=0.9,vi-VN;q=0.8,vi;q=0.7,en-GB;q=0.6,en-US;q=0.5' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
  --compressed -s  
  )
  resolved=$(echo "$response" | grep "data-options=" | sed 's/.*data-options=\"//' | sed 's/\".*//' | sed 's/.*u003Ehttps:/https:/g' | sed 's/\\\\u0026/\&/g' | sed 's/\&amp;/\&/g' | sed 's/\\\\.*//g')
  echo -e "\n{\"url\": \"${resolved}\"}"
else
  response=$(curl "$url" \
    -H 'accept-language: en-AU,en;q=0.9,vi-VN;q=0.8,vi;q=0.7,en-GB;q=0.6,en-US;q=0.5' \
    -H 'referer: https://ghienxemphim.net/' \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
    --compressed -s
    )
  resolved=$(echo "$response" | grep "controls src" | sed -e 's/.*controls src=\"//g' | sed -e 's/\".*//')
  echo -e "\n{\"url\": \"${resolved}\"}"
fi
  
