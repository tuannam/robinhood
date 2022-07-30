#!/bin/bash

source ./config.sh

FIRST=1
scan_category() {
	offset=0
	limit=10

	if [ $# -ge 2 ]; then
		offset=$2
	fi
	if [ $# -ge 3 ]; then
		limit=$3
	fi

	read -r -d '' DATA <<- EOM
		{
			"filter":"$1",
			"offset":$offset,
			"limit":$limit,
			"actionType":"getRelatedArticles"
		}
	EOM

	response=$(curl "${BASE_URL}webapi/index" \
		-H 'content-type: application/json' \
		-H "origin: ${BASE_URL}" \
		-H "referer: ${BASE_URL}category?id=$1" \
		-H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
		--data-raw "${DATA}" \
		--compressed -s)
		
	if [ ${#response} -lt 10 ]; then
		break
	fi

	echo "${response}"
}