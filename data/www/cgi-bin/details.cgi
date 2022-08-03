#!/usr/bin/env bash

source ./lib/common.sh

echo 'Content-Type: application/json'
echo ''

select_source
movie_id=$(urldecode ${QUERY_STRING})
details "$movie_id"