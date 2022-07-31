#!/usr/bin/env bash

source ./config.sh
source ./common.sh

echo 'Content-Type: application/json'

keyword=$(urldecode "$QUERY_STRING")

read -r -d '' PAYLOAD <<- EOM
	    {"q": "$keyword",
		"limit": 9,
		"actionType":"searchArticleByKeyword"}
	EOM

response=$(curl "${BASE_URL}webapi/index" \
  -H "referer: ${BASE_URL}" \
  -H "user-agent: ${USER_AGENT}" \
  --data-raw "${PAYLOAD}" \
  --compressed)

  echo "${response}"