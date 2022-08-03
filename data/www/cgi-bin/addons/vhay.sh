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

    count=$(echo "${html}" | xmllint --html -xpath 'count(//li[@class="TPostMv"])' - 2>/dev/null)
    idx=1
    echo -e "\n["
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