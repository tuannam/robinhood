#!/usr/bin/env bash

source ./lib/common.sh


echo 'Content-Type: application/json'
echo ''

select_source
url=$(urldecode ${QUERY_STRING})
resolve "$url"