#!/usr/bin/env bash

source ./lib/common.sh
source ./lib/cache.sh

echo 'Content-Type: application/json; charset=utf-8'
# echo 'Content-Type: text/plain'
echo ''

select_source

base="${HTTP_HOST}"
if [ "$SERVER_PORT" == "443" ]; then
    base="https://${base}"
else
    base="http://${base}"
fi

id=${QUERY_STRING}
if [ "$id" == "" ]; then
    id=$(list_categories | jq -r '.categories[0].id')
fi
name=$(list_categories | jq -r ".categories[] | select(.id==\"${id}\") | .name ")

next_id=$(next_category_id "$id")
next='null'
if [ "$next_id" != "null" ]; then
    next="\"${base}/cgi-bin/section_cont.cgi?${next_id}\""
fi

items=$(QUERY_STRING="$id" bash category.cgi | tail -n 2 )


read -r -d '' DATA <<- EOM
    {
        "tab": {
            "sections": [{
                "title": "${name}",
                "items": ${items},
                "next": null
            }],
            "next": ${next}
        }
    }
EOM

echo "${DATA}"

