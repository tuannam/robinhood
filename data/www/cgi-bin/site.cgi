#!/usr/bin/env bash

echo 'Content-Type: application/json'
echo ''

source ./lib/common.sh
list_addons

echo -n "["
first=1
for value in "${addons[@]}"
do
    if [ $first -eq 1 ]; then
        first=0
    else
        echo -n ', '
    fi
    echo -n "\"$value\""     
done
echo -e "]"