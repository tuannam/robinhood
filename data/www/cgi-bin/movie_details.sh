#!/bin/bash

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

	read -r -d '' JSON <<- EOM
	    {
			\t"code": "$article_code",
			\t"title": "$article_title",
			\t"image": "$article_image",		
	EOM
	echo -e "${JSON}" 
	
	extra_info=$(echo "${response}" | jq -r '.[].extra_info')
	echo -e "\t\"chapters\": [" 
	first=1
	echo "${extra_info}" | jq -c '.[]' | while read chapter; do
		name=$(echo "$chapter" | jq -r '.name')
		link=$(echo "$chapter" | jq -r '.link')	
		if [ $first -eq 1 ]; then			
			first=0
			echo -n -e "\t\t{\"name\": \"$name\", \"link\": \"$link\"}" 
		else
			echo "," 
			echo -n -e "\t\t{\"name\": \"$name\", \"link\": \"$link\"}" 
		fi
		
	done
	echo -e "\t]" 
		
	echo -n "}"  
}