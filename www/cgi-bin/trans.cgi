#!/usr/bin/env bash

# ffplay -headers 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
# -i "https://vd337.mycdn.me/?expires=1659825297871&srcIp=115.70.84.230&pr=10&srcAg=CHROME_MAC&ms=185.226.52.58&type=3&sig=4dDnl9_K9no&ct=4&urls=45.136.22.42&clientType=0&id=2851709323952" \
# -codec copy -f mpegts pipe:1 
echo 'content-type: application/x-mpegURL'
echo ''
  curl "https://play.animevhay.xyz/player/62c093b71810740f4c6ee14d/playlist.m3u8?v=10" \
  -H 'Referer: https://vhay.net' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36' \
  --compressed -s