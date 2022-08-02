#!/bin/bash

BASE_URL="https://ghienxemphim.net/"

list_categories() {
    read -r -d '' categories <<- EOM
    { 
        "categories": [
            { "name": "Phim Chiếu Rạp", "id": "4d5b4c6a5792"},
            { "name": "Phim Lẻ", "id": "2719c47fde33"},
            { "name": "Phim Bộ", "id": "0a0636677396"}
        ]
    }
EOM
    echo "${categories}"
}

movies_in_category() {
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