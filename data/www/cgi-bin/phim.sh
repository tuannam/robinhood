#!/bin/bash


CATEGORIES=( "2719c47fde33:Phim Lẻ"
			"4d5b4c6a5792:Phim Đề Xuất"
			"0a0636677396:Phim Bộ")
			
OUTPUT="/tmp/movies.json"			
			
movie_details() {
	read -r -d '' PAYLOAD <<- EOM
	    {"article_code":"$1",
		"filter_type":"extra",
		"actionType":"getArticleDetail"
	}
	EOM
		
    response=$(curl 'https://ghienxemphim.net/webapi/index' \
     -H 'content-type: application/json' \
     -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
     --data-raw "${PAYLOAD}" \
     --compressed -s)
		 
	article_code=$(echo "${response}" | jq -r '.[].article_code')
	article_title=$(echo "${response}" | jq -r '.[].article_title')
	article_image=$(echo "${response}" | jq -r '.[].article_image')	
	# echo "${response}" | jq -r '.[] | .cat_code_arr, .article_code, .article_title, .article_image, .extra_info'
	# echo "${response}" | jq -r '.[] '
	read -r -d '' JSON <<- EOM
	    {
			\t"code": "$article_code",
			\t"title": "$article_title",
			\t"image": "$article_image",		
	EOM
	echo -e "${JSON}" >> $OUTPUT
	
	extra_info=$(echo "${response}" | jq -r '.[].extra_info')
	echo -e "\t\"chapters\": [" >> $OUTPUT
	first=1
	echo "${extra_info}" | jq -c '.[]' | while read chapter; do
		name=$(echo "$chapter" | jq -r '.name')
		link=$(echo "$chapter" | jq -r '.link')	
		if [ $first -eq 1 ]; then			
			first=0
			echo -n -e "\t\t{\"name\": \"$name\", \"link\": \"$link\"}" >> $OUTPUT		
		else
			echo "," >> $OUTPUT
			echo -n -e "\t\t{\"name\": \"$name\", \"link\": \"$link\"}" >> $OUTPUT
		fi
		
	done
	echo -e "\t]" >> $OUTPUT
		
	echo -n "}"  >> $OUTPUT
}

FIRST=1
scan_category() {
	offset=0
	while [ $offset -lt 1000 ]; do
		read -r -d '' DATA <<- EOM
		    {
				"filter":"$1",
				"offset":$offset,
				"limit":12,
				"actionType":"getRelatedArticles"
			}
		EOM
	
		response=$(curl 'https://ghienxemphim.net/webapi/index' \
		  -H 'content-type: application/json' \
		  -H 'origin: https://ghienxemphim.net' \
		  -H "referer: https://ghienxemphim.net/category?id=$1" \
		  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
		  --data-raw "${DATA}" \
		  --compressed -s)
		  
		if [ ${#response} -lt 10 ]; then
			break
		fi
	
		for article_code in  $(echo "$response" | jq -r '.[].article_code'); do
			if [ $FIRST -eq 1 ]; then
				FIRST=0				
			else
				echo "," >> $OUTPUT
			fi
			movie_details "${article_code}"
		done
		offset=$((offset+12))
	done	
}

echo "[" > $OUTPUT
for category in "${CATEGORIES[@]}" ; do
    KEY=${category%%:*}
    VALUE=${category#*:}
	scan_category $KEY
done

echo "]" >> $OUTPUT







