#!/usr/bin/env bash

source ./common.sh

echo 'Content-Type: application/json'

keyword=$(urldecode "$QUERY_STRING")
select_source
search "$keyword"