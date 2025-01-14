#!/bin/bash

source ./lib/common.sh

BASE_URL="https://hayghe.club/"
USER_AGENT='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'

list_categories() {
    read -r -d '' categories <<- EOM
    { 
        "categories": [
            { "name": "Phim Lẻ", "id": "phim-le/0"},
            { "name": "Phim Bộ", "id": "phim-bo/0"},
            { "name": "Phim Thuyết Minh", "id": "phim-thuyet-minh/0"}
        ]
    }
EOM
    echo "${categories}"
}

movies_in_category() {
    category_id="$1"
    parts=(${category_id//\// })

    offset=$2
    url="${BASE_URL}${parts[0]}/"

    if [ $offset -gt 0 ]; then
        page=$((offset/25 + 1))
        url="${url}trang-${page}.html"
    fi

    html=$(curl "${url}" \
    -H "referer: ${BASE_URL}" \
    -H "user-agent: ${USER_AGENT}" \
    --compressed -s)

    count=$(echo "${html}" | xmllint --html -xpath "count(//li[@class='TPostMv'])" - 2>/dev/null)
    idx=1
    echo -e "["
    while [ $idx -le $count ]; do        
        title=$(echo "$html" | xmllint --html -xpath "//li[@class='TPostMv'][$idx]/article/a/h2/text()" - 2>/dev/null)
        image=$(echo "$html" | xmllint --html -xpath "string(//li[@class='TPostMv'][$idx]/article/a/div/figure/img/@src)" - 2>/dev/null)
        code=$(echo "$html" | xmllint --html -xpath "string(//li[@class='TPostMv'][$idx]/article/a/@href)" - 2>/dev/null | cut -c 26-)
        title1=$(echo "${title}" | cut -d':' -f1)
        title2=$(echo "${title}" | cut -d':' -f2 | xargs)
        if [ $idx -ne 1 ]; then
            echo ","
        fi
        echo "{"
        echo "\"article_code\": \"${code}\"",
        echo "\"article_image\": \"${image}\"",
        echo "\"article_title\": \"${title1}\"",
        echo "\"article_title_en\": \"${title2}\""
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

    title=$(echo "$html" | xmllint --html -xpath "//h1[@class='Title']/text()" - 2>/dev/null)
    subTitle=$(echo "$html" | xmllint --html -xpath "//h2[@class='SubTitle']/text()" - 2>/dev/null)
    image=$(echo "$html" | xmllint --html -xpath "string(//figure/img/@src)" - 2>/dev/null)
    content=$(echo "$html" | xmllint --html -xpath "//header/div[@class='Description']" - 2>/dev/null )
    escaped_content=$(urldecode "${content}" | sed 's/<.*>//g' | jq -Rsa . )

    url="${BASE_URL}phim/$1/xem-phim.html"
	# echo "$url"
    html=$(curl "${url}" \
            -H "referer: ${BASE_URL}' \
            -H user-agent: ${USER_AGENT}" \
            --compressed -s)

    extra_info="["
    server_xpath="//div[ul[starts-with(@class,'list-episode')]]"
    serverCount=$(echo "$html" | xmllint --html -xpath "count(${server_xpath})" - 2>/dev/null)
    serverIdx=1

    while [ $serverIdx -le $serverCount ]; do
        serverName=$(echo "$html" | xmllint --html -xpath "${server_xpath}[$serverIdx]/h3/text()" - 2>/dev/null | sed 's/ $//' | sed 's/^ //' | jq -Rsa . )
        chapterCount=$(echo "$html" | xmllint --html -xpath "count(${server_xpath}[$serverIdx]/ul/li)" - 2>/dev/null)
        chapterIdx=1
        server_info="{ \"server\": ${serverName}, \"chapters\": ["
        while [ $chapterIdx -le $chapterCount ]; do
            chapter_xpath="${server_xpath}[$serverIdx]/ul/li[${chapterIdx}]"
            link=$(echo "$html" | xmllint --html -xpath "string(${chapter_xpath}/a/@href)" - 2>/dev/null | xargs basename)
            name=$(echo "$html" | xmllint --html -xpath "${chapter_xpath}/a/text()" - 2>/dev/null)

            if [ $chapterIdx -gt 1 ]; then
                 server_info="${server_info}, "
            fi
            chapter=$(echo -en "Tập ${name}" | jq -Rsa .)
            server_info="${server_info}{ \"name\": ${chapter}, \"link\": \"resolver-$1/${link}\" }"

            chapterIdx=$((chapterIdx+1))
        done
        server_info="${server_info}]}"

        if [ ${#extra_info} -gt 1 ]; then
            extra_info="${extra_info}, "
        fi
        extra_info="${extra_info}${server_info}"
        serverIdx=$((serverIdx+1))
    done

    extra_info="${extra_info}]"

    read -r -d '' DATA <<- EOM
		[{
			"article_title": "${title}",
            "article_title_en": "${subTitle}",
			"article_image": "${image}",
            "article_content": ${escaped_content},
            "extra_info": ${extra_info}
		}]
	EOM

    echo "$DATA" 
}

search() {
    keyword="$1"
    html=$(curl "${BASE_URL}/tim-kiem/${keyword}/" \
        -H "referer: ${BASE_URL}" \
        -H "user-agent: ${USER_AGENT}" \
        --compressed -s)

    count=$(echo "$html" | xmllint --html -xpath "count(//ul[starts-with(@class, 'MovieList')]/li[@class='TPostMv'])" - 2>/dev/null)
    idx=1
    echo "["
    while [ $idx -le $count ]; do        
        # item=$(echo "$html" | xmllint --html -xpath "//ul[starts-with(@class, 'MovieList')]/li[@class='TPostMv'][$idx]" - 2>/dev/null)
        link=$(echo "$html" | xmllint --html -xpath "string(//ul[starts-with(@class, 'MovieList')]/li[@class='TPostMv'][$idx]/*/a/@href)" - 2>/dev/null | xargs basename)
        # name=$(echo "$item" | xmllint --html -xpath "string(//h2/text())" - 2>/dev/null)
        image=$(echo "$html" | xmllint --html -xpath "string(//ul[starts-with(@class, 'MovieList')]/li[@class='TPostMv'][$idx]/article/a/div/figure/img/@src)" - 2>/dev/null)
        name=$(echo "$html" | xmllint --html -xpath "string(//ul[starts-with(@class, 'MovieList')]/li[@class='TPostMv'][$idx]/article/a/div/figure/img/@alt)" - 2>/dev/null)
		title=$(echo "$name" | cut -d'-' -f1 | sed 's/ $//'| tr -d '\n' | jq -Rsa .)
		title_en=$(echo "$name" | cut -d'-' -f2 | sed 's/ $//'| tr -d '\n' | jq -Rsa .)

        if [ $idx -gt 1 ]; then
            echo ", "
        fi
        echo -n "{"
        echo "\"article_code\": \"${link}\"",
        echo "\"article_image\": \"${image}\"",
        echo "\"article_title\": ${title}",
		echo "\"article_title_en\": ${title_en}"
        echo -n "}"

        idx=$((idx+1))
    done
    echo "]"
}

resolve() {
    query="$1"
    url1="${BASE_URL}phim/${query:9}"

    html=$(curl "$url1" \
        -H "referer: ${BASE_URL}" \
        -H "user-agent: ${USER_AGENT}" \
        --compressed -s)

    episodeID=$(echo "${html}" | grep "filmInfo.episodeID =" | cut -d"'" -f2)
    filmID=$(echo "${html}" | grep "filmInfo.filmID =" | cut -d"'" -f2)
    playTech=$(echo "${html}" | grep "filmInfo.playTech =" | cut -d"'" -f2)
	# echo "episodeID: $episodeID filmID: $filmID"

    html=$(curl "${BASE_URL}ajax" \
            -H "referer: ${BASE_URL}" \
            -H "user-agent: ${USER_AGENT}" \
            --data-raw "NextEpisode=1&EpisodeID=${episodeID}&filmID=${filmID}&playTech=${playTech}" \
            --compressed -s )
	# echo "$html"

    url=$(echo "$html" | sed 's/.*<iframe//' | sed "s/.*src='http/http/" | sed 's/.*src="//' | sed "s/'.*//" | sed 's/".*//')
    # echo "$url"
    if [[ $url == https://play.animevhay.xyz* ]] ; then
        id=$(echo "$url" | sed 's/.*id=//')
		url="https://play.animevhay.xyz/player/${id}/playlist.m3u8?v=10"
	    echo "{\"url\": \"${url}\", \"type\": \"video/mp4\", \"player\": \"ok.ru\"}"
        exit 0
    fi 
      
    if [[ $url == https://fembed.com* ]] ; then
        id=$(echo "$url" | sed 's/.*\///g')
        r=$(jq -rn --arg x "$url1" '$x|@uri')
        mediaUrl=$(curl -s "https://vanfem.com/api/source/$id" \
        --data-raw "r=$r&d=vanfem.com" | jq -r '.data[-1].file')
        echo "{\"url\": \"${mediaUrl}\", \"type\": \"video/mp4\", \"player\": \"vanfem.com\"}"
        exit 0
    fi
    
    if [[ $url == https://ok.ru* ]] ; then
        response=$(curl "$url" \
                    -H 'authority: ok.ru' \
                    --compressed -s
                    )
        resolved=$(echo "$response" | grep "data-options=" | sed 's/.*data-options=\"//' | sed 's/\".*//' | sed 's/.*u003Ehttps:/https:/g' | sed 's/\\\\u0026/\&/g' | sed 's/\&amp;/\&/g' | sed 's/\\\\.*//g')
        echo "{\"url\": \"${resolved}\", \"type\": \"video/mp4\", \"player\": \"ok.ru\"}"
        exit 0
    fi

    echo "{\"url\": \"${url}\", \"type\": \"video/mp4\"}"
}


