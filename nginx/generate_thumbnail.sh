#!/bin/sh

# 스크립트 디버깅을 위한 설정
set -ex

# 'generate_thumbnail' 애플리케이션에서 전달받은 스트림 키
STREAM_NAME=$1

# ✅ [핵심] 썸네일 생성 및 알림 루프를 '안전한 한 줄'로 작성하여,
# 보이지 않는 공백이나 줄바꿈 문자로 인한 파싱 오류 가능성을 원천적으로 차단합니다.
(while true; do ffmpeg -i rtmp://localhost:1935/generate_thumbnail/$STREAM_NAME -vframes 1 -vf scale=1280:720 -y /opt/data/thumbnails/${STREAM_NAME}.jpg && curl -X PUT -H "Content-Type: application/json" -d '{"thumbnailUrl":"http://192.168.0.31/thumbnails/'$STREAM_NAME'.jpg"}' http://192.168.0.31:8080/rtmp/$STREAM_NAME/thumbnails; sleep 3600; done) &