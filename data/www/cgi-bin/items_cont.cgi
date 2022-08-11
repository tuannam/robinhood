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


query=${QUERY_STRING}
parts=(${query//\// })
category="${parts[0]}/${parts[1]}"

offset=0
limit=15
if [ ${#parts[@]} -ge 3 ]; then
    offset=${parts[2]}
fi

if [ ${#parts[@]} -ge 4 ]; then
    limit=${parts[3]}
fi

select_source

items=$(QUERY_STRING="$query" bash category.cgi | tail -n 2)
item_count=$(echo "$items" | jq -r '. | length')
if [ $item_count -gt 0 ]; then
	offset=$((offset+item_count))
	next="\"${category}/${offset}/${limit}\""
fi

read -r -d '' DATA <<- EOM
    {
        "items": ${items},
		"next": ${next}
    }
EOM

echo "${DATA}"

