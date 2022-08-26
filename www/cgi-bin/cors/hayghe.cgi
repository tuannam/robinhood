#!/usr/bin/env bash

echo 'Content-Type: text/plain'
echo ''
url="https://$QUERY_STRING"
# echo "$url"
curl "$url" \
-H "referer: https://play.animevhay.xyz"