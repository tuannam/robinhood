#!/bin/bash

CACHE_FOLDER='../cache/'

get_cache() {
    key=$1
    cache_file="${CACHE_FOLDER}${key}"
    if [ -f "$cache_file" ]; then
        cat "$cache_file"        
    fi
}

set_cache() {
    key=$1
    data="$2"
    cache_file="${CACHE_FOLDER}${key}"
    folder=$(dirname "${cache_file}")
    mkdir -p "${folder}"
    echo "$data" > "$cache_file"
}