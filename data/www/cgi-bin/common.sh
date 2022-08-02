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