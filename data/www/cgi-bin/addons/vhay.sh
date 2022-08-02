#!/bin/bash

BASE_URL="https://ghienxemphim.net/"
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