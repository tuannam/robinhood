#!/usr/bin/env bash

echo 'Content-Type: application/json'
echo ''

read -r -d '' DATA <<- EOM
{
    "version": "1.0.2",
    "url": "https://robinhood.swiftit.net/download/rh-1.0.2.apk"
}
EOM

echo "$DATA" 