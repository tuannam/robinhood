#!/usr/bin/env bash

source ./config.sh
source ./common.sh

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
-H "user-agent: ${USER_AGENT}" \
--data-raw "${PAYLOAD}" \
--compressed -s)

echo "${response}"