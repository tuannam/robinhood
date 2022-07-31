#!/usr/bin/env bash
source ./common.sh

echo 'Content-Type: text/plain'
echo ''

zzz=$(urldecode "$QUERY_STRING")
echo "Output2: $zzz"