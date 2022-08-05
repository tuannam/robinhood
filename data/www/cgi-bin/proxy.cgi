
#!/usr/bin/env bash

source ./lib/common.sh

query=${QUERY_STRING}
url=$(urldecode "$query")

curl "$url" \
    -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' 
