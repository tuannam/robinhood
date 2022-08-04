#!/bin/bash

BASE_URL="https://vhay.net/"
USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'

list_categories() {
    read -r -d '' categories <<- EOM
    { 
        "categories": [
            { "name": "Phim Lẻ", "id": "phim-le"},
            { "name": "Phim Bộ", "id": "phim-bo"},
            { "name": "Phim Thuyết Minh", "id": "phim-thuyet-minh"}
        ]
    }
EOM
    echo "${categories}"
}

movies_in_category() {
    category_id="$1"
    offset=$2
    url="${BASE_URL}${category_id}/"

    if [ $offset -gt 0 ]; then
        page=$((offset/25 + 1))
        url="${url}trang-${page}.html"
    fi

    html=$(curl "${url}" \
    -H 'referer: https://vhay.net/' \
    -H "user-agent: ${USER_AGENT}" \
    --compressed -s)

    count=$(echo "${html}" | 
    )
    idx=1
    echo -e "["
    while [ $idx -le $count ]; do
        item=$(echo "${html}" | xmllint --html -xpath "//li[$idx][@class='TPostMv']" - 2>/dev/null)
        title=$(echo "$item" | xmllint --html -xpath "string(//h2)" - 2>/dev/null)
        image=$(echo "$item" | xmllint --html -xpath "string(//img/@src)" - 2>/dev/null)
        code=$(echo "$item" | xmllint --html -xpath "string(//a/@href)" - 2>/dev/null | cut -c 23-)
        if [ $idx -ne 1 ]; then
            echo ","
        fi
        echo "{"
        echo "\"article_code\": \"${code}\"",
        echo "\"article_image\": \"${image}\"",
        echo "\"article_title\": \"${title}\""
        echo -n "}"
        idx=$((idx+1))
    done
    echo "]"    
}


details() {
    url="${BASE_URL}phim/$1"
    html=$(curl "${url}" \
            -H "referer: ${BASE_URL}' \
            -H user-agent: ${USER_AGENT}" \
            --compressed -s)

# echo "$html"
    title=$(echo "$html" | xmllint --html -xpath "//h1[@class='Title']/text()" - 2>/dev/null)
    subTitle=$(echo "$html" | xmllint --html -xpath "//h2[@class='SubTitle']/text()" - 2>/dev/null)
    image=$(echo "$html" | xmllint --html -xpath "string(//figure/img/@src)" - 2>/dev/null)
    content=$(echo "$html" | xmllint --html -xpath "//header/div[@class='Description']/text()" - 2>/dev/null)
    escaped_content=$(echo -n "<div>${content}</div>" | jq -Rsa . )

    read -r -d '' DATA <<- EOM
		[{
			"article_title": "${title} - ${subTitle}",
			"article_image": "${image}",
            "article_content": ${escaped_content},
            "extra_info": []
		}]
	EOM

    echo "$DATA" 
}