#!/usr/bin/env bash

echo 'Content-Type: text/plain'
echo ''

query="$QUERY_STRING"
id=$(echo "$query" | cut -d'/' -f2)
# echo "$query"
# echo $id

base="${HTTP_HOST}"
if [ "$SERVER_PORT" == "443" ]; then
    scheme="https"
else
    scheme="http"
fi

curl "https://play.animevhay.xyz/player/$id/playlist.m3u8?v=10" \
-H "referer: https://play.animevhay.xyz/public/index.html?id=$id" | sed -r "s/https:\/\//$scheme:\/\/$base\/hayghe\//g"