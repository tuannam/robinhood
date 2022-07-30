#!/usr/bin/env bash

echo 'Content-Type: application/json'
source ./scan_caletory.sh

CATEGORIES=( "phimle:2719c47fde33"
			"phimbo:0a0636677396"
			"phimchieurap:4d5b4c6a5792")

query=${QUERY_STRING}
key="phimchieurap"
query=${QUERY_STRING}
parts=(${query//\// })
key=${parts[0]}

offset=0
size=12
if [ ${#parts[@]} -ge 2 ]; then
    offset=${parts[1]}
fi

if [ ${#parts[@]} -ge 3 ]; then
    size=${parts[2]}
fi

for category in "${CATEGORIES[@]}" ; do
    KEY=${category%%:*}
    VALUE=${category#*:}
	if [ "$KEY" == "$key" ]; then
        value=$VALUE
        break
    fi
done

scan_category "$value" $offset $size
