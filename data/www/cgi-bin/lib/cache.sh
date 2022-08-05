#!/bin/bash

CACHE_FOLDER='../cache/'
cache=1

get_cache() {    
    if [ $cache -eq 0 ]; then
        return
    fi

    key=$1

    if [ "$HTTP_X_MOVIE_SITE" == "" ]; then
        HTTP_X_MOVIE_SITE="${addons[0]}"
    fi

    cache_file="${CACHE_FOLDER}${HTTP_X_MOVIE_SITE}/${key}"
    if [ -f "$cache_file" ]; then
        cat "$cache_file"        
    fi
}

set_cache() {
    key=$1
    data="$2"

    if [ "$HTTP_X_MOVIE_SITE" == "" ]; then
        HTTP_X_MOVIE_SITE="${addons[0]}"
    fi

    cache_file="${CACHE_FOLDER}${HTTP_X_MOVIE_SITE}/${key}"
    folder=$(dirname "${cache_file}")
    mkdir -p "${folder}"
    echo "$data" > "$cache_file"
}