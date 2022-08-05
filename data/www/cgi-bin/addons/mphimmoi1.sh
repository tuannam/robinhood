#!/bin/bash

BASE_URL="https://mphimmoi1.com/"
USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'

list_categories() {
    read -r -d '' categories <<- EOM
    { 
        "categories": [
            { "name": "Phim Mới", "id": "danh-sach/phim-moi"},
            { "name": "Phim chiếu rạp", "id": "danh-sach/phim-chieu-rap"},
            { "name": "Phim Lẻ", "id": "danh-sach/phim-le"},
            { "name": "Phim Bộ", "id": "danh-sach/phim-bo"},
            { "name": "Netflix", "id": "the-loai/netflix"}
        ]
    }
EOM
    echo "${categories}"
}

movies_in_category() {
    url="${BASE_URL}$1.html"
    if [ $offset -gt 0 ]; then
        page=$((offset/15 + 1))
        url="${BASE_URL}$1/trang-${page}.html"
    fi

    html=$(curl "${url}" \
            -H "referer: ${BASE_URL}" \
            -H "user-agent: ${USER_AGENT}" \
            --compressed -s)
    count=$(echo "$html" | xmllint --html -xpath "count(//li[@class='film-item '])" - 2>/dev/null)

    idx=1
    echo -e "["
    while [ $idx -le $count ]; do
        item=$(echo "$html" | xmllint --html -xpath "//li[@class='film-item '][$idx]" - 2>/dev/null)
        name=$(echo "$item" | xmllint --html -xpath "//div/p[@class='name']/text()" - 2>/dev/null)
        link=$(echo "$item" | xmllint --html -xpath "string(//a/@href)" - 2>/dev/null | xargs basename )
        image=$(echo "$item" | xmllint --html -xpath "string(//img/@src)" - 2>/dev/null)

        # echo "$item"        

        if [ $idx -ne 1 ]; then
            echo ","
        fi
        echo "{"
        echo "\"article_code\": \"${link%.*}\"",
        echo "\"article_image\": \"${image}\"",
        echo "\"article_title\": \"${name}\""
        echo -n "}"

        idx=$((idx+1))
    done
    echo "]"    
}


details() {
    url="${BASE_URL}$1.html"
    html=$(curl ${url} \
            -H "referer: ${BASE_URL}" \
            -H "user-agent: ${USER_AGENT}" \
            --compressed -s)

    # echo "$html"
    title=$(echo "$html" | xmllint --html -xpath "//h1[@class='name']/text()" - 2>/dev/null | sed 's/ *$//g' | tr -d '\n')
    subTitle=$(echo "$html" | xmllint --html -xpath "//h2[@class='real-name']/text()" - 2>/dev/null | cut -d '|' -f 2 | sed 's/ *$//g' | tr -d '\n')
    image=$(echo "$html" | xmllint --html -xpath "string(//div[@class='poster']/a/img/@src)" - 2>/dev/null)
    content=$(echo "$html" | xmllint --html -xpath "//div[@class='film-content']/p/text()" - 2>/dev/null)
    full_link=$(echo "$html" | xmllint --html -xpath "string(//a[i[@class='fa fa-play']]/@href)" - 2>/dev/null)
    # escaped_content=$(echo -n "<div>${content}</div>" | jq -Rsa . )

    html=$(curl ${full_link} \
            -H "referer: ${BASE_URL}" \
            -H "user-agent: ${USER_AGENT}" \
            --compressed -s)

    count=$(echo "${html}" | xmllint --html -xpath "count(//ul[@class='list-episode']/li)" - 2>/dev/null)
    idx=1
    extra_info="["
    while [ $idx -le $count ]; do
        item=$(echo "${html}" | xmllint --html -xpath "//ul[@class='list-episode']/li[$idx]" - 2>/dev/null)
        chapter_link=$(echo "$item" | xmllint --html -xpath "string(//a/@href)" - | xargs basename)
        chapter=$(echo "$item" | xmllint --html -xpath "//a/text()" -)

        if [ $idx -gt 1 ]; then
            extra_info="${extra_info}, "        
        fi
        extra_info="${extra_info}{ \"name\": \"Tap ${chapter}\", \"link\": \"resolver-${chapter_link}\" }"

        idx=$((idx+1))
    done
    extra_info="${extra_info}]"

    read -r -d '' DATA <<- EOM
		[{
			"article_title": "${title} - ${subTitle}",
			"article_image": "${image}",
            "article_content": "<div>${content}</div>",
            "extra_info": ${extra_info}
		}]
	EOM

    echo "$DATA" 
}

search() {
    keyword="$1"
    html=$(curl "${BASE_URL}ajax/search/" \
    -H "referer: ${BASE_URL}" \
    --data-raw "keyword=${keyword}" \
    --compressed -s | jq -r '.content')
    count=$(echo "$html" | xmllint --html -xpath "count(//ul/li[@class='film'])" -)
    idx=1
    echo "["
    while [ $idx -le $count ]; do
        item=$(echo "$html" | xmllint --html -xpath "//ul/li[@class='film'][$idx]" -)
        image=$(echo "$item" | xmllint --html -xpath "string(//img/@src)" -)
        link=$(echo "$item" | xmllint --html -xpath "string(//a/@href)" - | xargs basename)
        name=$(echo "$item" | xmllint --html -xpath "//a/span/text()" - | sed 's/ //g')
        if [ $idx -gt 1 ]; then
            echo ", "
        fi
        echo -n "{"
        echo "\"article_code\": \"${link%.*}\"",
        echo "\"article_image\": \"${image}\"",
        echo "\"article_title\": \"${name}\""
        echo -n "}"
        idx=$((idx+1))
    done
    echo "]"
}

resolve() {
    query="$1"
    url="${BASE_URL}${query:9}"

    html=$(curl "$url" \
        -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
        --compressed -s)
    episodeID=$(echo "${html}" | grep "var episodeID =" | sed 's/.*parseInt(//' | sed 's/).*//')
    filmID=$(echo "${html}" | grep "filmID = parseInt" | sed 's/.*parseInt(//' | sed 's/).*//')
    svID=$(echo "${html}" | grep "var svID =" | sed 's/.*parseInt(//' | sed 's/).*//')

    html=$(curl "${BASE_URL}ajax/player" \
            -H "referer: ${BASE_URL}" \
            -H "user-agent: ${USER_AGENT}" \
            --data-raw "id=${filmID}&ep=${episodeID}&server=${svID}" \
            --compressed -s)

    url=$(echo "$html" | grep "sources: " | sed 's/.*file: \"//' | sed 's/\".*//')
    echo "{\"url\": \"${url}\", \"type\": \"application/x-mpegURL\"}"
}