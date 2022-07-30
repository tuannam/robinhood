#!/usr/bin/env bash

source ./config.sh

echo 'Content-Type: application/json'
query=${QUERY_STRING}

read -r -d '' PAYLOAD <<- EOM
	    {"article_code":"$query",
		"filter_type":"extra",
		"actionType":"getArticleDetail"
	}
	EOM
		
response=$(curl "${BASE_URL}webapi/index" \
-H 'content-type: application/json' \
-H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
--data-raw "${PAYLOAD}" \
--compressed -s)

echo "${response}"