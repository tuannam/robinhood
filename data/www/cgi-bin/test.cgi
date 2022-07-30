#!/bin/bash


CATEGORIES=( "phimle:2719c47fde33"
			"phimbo:0a0636677396"
			"phimchieurap:4d5b4c6a5792")

key='phimchieurap'
value="4d5b4c6a5792"

query=${QUERY_STRING}

parts=(${query//\// })
key=${parts[0]}   

echo 'Content-Type: text/plain'
echo ''

for category in "${CATEGORIES[@]}" ; do
    KEY=${category%%:*}
    VALUE=${category#*:}
	if [ "$KEY" == "$key" ]; then
        value=$VALUE
        break
    fi
done

echo "query: ${query}"
echo "key: ${key}"
echo "Hello: '${value}'"
echo "parts: ${parts[2]}"
