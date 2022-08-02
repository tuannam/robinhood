#!/bin/bash

BASE_URL="https://ghienxemphim.net/"
USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'

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


details() {
    movie_id=$1
    read -r -d '' PAYLOAD <<- EOM
	    {"article_code":"$movie_id",
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
}

search() {
    $keyword=$1
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
}

resolve() {
    url="$1"
    if [[ "$url" == *"ok.ru"* ]]; then
    response=$(curl "$url" \
    -H 'authority: ok.ru' \
    -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
    -H 'accept-language: en-AU,en;q=0.9,vi-VN;q=0.8,vi;q=0.7,en-GB;q=0.6,en-US;q=0.5' \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
    --compressed -s  
    )
    resolved=$(echo "$response" | grep "data-options=" | sed 's/.*data-options=\"//' | sed 's/\".*//' | sed 's/.*u003Ehttps:/https:/g' | sed 's/\\\\u0026/\&/g' | sed 's/\&amp;/\&/g' | sed 's/\\\\.*//g')
    echo -e "\n{\"url\": \"${resolved}\"}"
    else
    response=$(curl "$url" \
        -H 'accept-language: en-AU,en;q=0.9,vi-VN;q=0.8,vi;q=0.7,en-GB;q=0.6,en-US;q=0.5' \
        -H "referer: ${BASE_URL}" \
        -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
        --compressed -s
        )
    resolved=$(echo "$response" | grep "controls src" | sed -e 's/.*controls src=\"//g' | sed -e 's/\".*//')
    echo -e "\n{\"url\": \"${resolved}\"}"
    fi
}