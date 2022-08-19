#!/bin/bash

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

addons=()

list_addons() {
    for addon in ./addons/*.sh
    do
        filename=$(basename $addon)
        addons+=("${filename%.*}")
    done
}

select_source() {
    list_addons

    if [ "$HTTP_X_MOVIE_SITE" == "" ]; then
        HTTP_X_MOVIE_SITE="${addons[0]}"
    fi
    source ./addons/${HTTP_X_MOVIE_SITE}.sh
}

next_category_id() {
    id="$1"
    idx=$(list_categories | jq  -r '[.categories[].id] | to_entries' | jq -r ".[] | select(.value==\"${id}\") | .key")
    next_idx=$((idx+1))
    next_id=$(list_categories | jq -r ".categories[${next_idx}].id")
    echo "${next_id}"
}