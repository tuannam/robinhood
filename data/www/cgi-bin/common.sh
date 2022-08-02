#!/bin/bash

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }
USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'

addons=()

list_addons() {
    for addon in ./addons/*.sh
    do
        filename=$(basename $addon)
        addons+=("${filename%.*}")
    done
}

select_source() {    
    if [ "$SOURCE" == "" ]; then
        SOURCE="${addons[0]}"
    fi
    source ./addons/${SOURCE}.sh
}