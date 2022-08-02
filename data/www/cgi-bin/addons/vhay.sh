#!/bin/bash

BASE_URL="https://vhay.net/"
USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'

list_categories() {
    read -r -d '' categories <<- EOM
    { 
        "categories": [
            { "name": "XXX", "id": "4d5b4c6a5792"},
            { "name": "YYY", "id": "2719c47fde33"},
            { "name": "ZZZ", "id": "0a0636677396"}
        ]
    }
EOM
    echo "${categories}"
}

movies_in_category() {
    html=$(curl "${BASE_URL}phim-le/" \
    -H 'referer: https://vhay.net/' \
    -H "user-agent: ${USER_AGENT}" \
    --compressed -s)

    count=$(echo "${html}" | xmllint --html -xpath 'count(//li[@class="TPostMv"])' - 2>/dev/null)
    echo "$count"
    idx=1
    while [ $idx -le $count ]; do
        item=$(echo "${html}" | xmllint --html -xpath "//li[$idx][@class='TPostMv']" - 2>/dev/null)
        echo "$item"
        echo "============================"
        idx=$((idx+1))
    done
    
}

movies_in_category