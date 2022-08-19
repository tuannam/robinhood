#!/usr/bin/env bash

source ./lib/common.sh
source ./lib/cache.sh

echo 'Content-Type: application/json'
echo ''

select_source
movie_id=$(urldecode ${QUERY_STRING})

cache_file="movies/${movie_id}.cache"
cache_data=$(get_cache "$cache_file")

if [ "$cache_data" == "" ]; then
    cache_data=$(details "$movie_id")   
    if [ ${#cache_data} -gt 5 ]; then
        set_cache "${cache_file}" "${cache_data}"
    fi
fi

echo "${cache_data}"