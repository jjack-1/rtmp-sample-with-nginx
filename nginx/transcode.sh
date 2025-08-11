#!/bin/sh

# 스크립트 디버깅을 위한 설정
set -ex

# 'live' 애플리케이션에서 전달받은 스트림 키($name)를 변수에 저장합니다.
STREAM_NAME=$1

# ✅ 다중 해상도 FFmpeg 트랜스코딩 (3개 화질: 1080p + 720p + 480p)
# ✅ [핵심] 모든 ffmpeg 옵션을 줄바꿈 없이 하나의 라인으로 작성하여,
# 보이지 않는 공백이나 줄바꿈 문자로 인한 파싱 오류 가능성을 원천적으로 차단합니다.
ffmpeg -i rtmp://localhost:1935/live/$STREAM_NAME -c:v libx264 -b:v 6000k -maxrate 6000k -bufsize 12000k -vf scale=1920:1080 -r 60 -g 120 -keyint_min 120 -preset fast -profile:v high -level 4.2 -c:a aac -b:a 192k -ar 44100 -ac 2 -f flv rtmp://localhost:1935/hls/${STREAM_NAME}_1080p -c:v libx264 -b:v 4000k -maxrate 4000k -bufsize 8000k -vf scale=1280:720 -r 60 -g 120 -keyint_min 120 -preset superfast -profile:v high -level 4.2 -c:a aac -b:a 128k -ar 44100 -ac 2 -f flv rtmp://localhost:1935/hls/${STREAM_NAME}_720p -c:v libx264 -b:v 1200k -maxrate 1200k -bufsize 2400k -vf scale=854:480 -r 30 -g 60 -keyint_min 60 -preset superfast -profile:v baseline -c:a aac -b:a 128k -ar 44100 -ac 2 -f flv rtmp://localhost:1935/hls/${STREAM_NAME}_480p &