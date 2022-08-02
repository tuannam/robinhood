#!/usr/bin/env bash

source ./common.sh

echo 'Content-Type: application/json'

select_source
movie_id=$(urldecode ${QUERY_STRING})
details "$movie_id"