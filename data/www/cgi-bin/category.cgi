#!/usr/bin/env bash

source ./common.sh

echo 'Content-Type: application/json'


query=${QUERY_STRING}
query=${QUERY_STRING}
parts=(${query//\// })
category=${parts[0]}

offset=0
size=12
if [ ${#parts[@]} -ge 2 ]; then
    offset=${parts[1]}
fi

if [ ${#parts[@]} -ge 3 ]; then
    size=${parts[2]}
fi

select_source

movies_in_category ${category} ${offset} ${limit}
