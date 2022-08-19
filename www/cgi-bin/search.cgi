#!/usr/bin/env bash

source ./lib/common.sh

echo 'Content-Type: application/json'
echo ''

keyword=$(urldecode "$QUERY_STRING")
select_source
search "$keyword"