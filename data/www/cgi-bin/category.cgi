#!/usr/bin/env bash

source ./lib/common.sh
source ./lib/cache.sh

echo 'Content-Type: application/json'
echo ''

query=${QUERY_STRING}
parts=(${query//\// })
category=${parts[0]}

offset=0
limit=15
if [ ${#parts[@]} -ge 2 ]; then
    offset=${parts[1]}
fi

if [ ${#parts[@]} -ge 3 ]; then
    limit=${parts[2]}
fi

select_source

cache_file="${category}/${offset}/${limit}.cache"
cache_data=$(get_cache "$cache_file")

if [ "$cache_data" == "" ]; then
    cache_data=$(movies_in_category ${category} ${offset} ${limit})   
    if [ ${#cache_data} -gt 5 ]; then
        set_cache "${cache_file}" "${cache_data}"
    fi
fi

echo "${cache_data}"