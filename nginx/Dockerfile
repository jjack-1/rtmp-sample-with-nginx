# alfg/nginx-rtmp 이미지 사용 (ffmpeg 내장)
FROM alfg/nginx-rtmp

# ✅ [핵심 해결책]
# 1. 필수 패키지 설치: 'dos2unix'가 바로 윈도우 형식 파일을 리눅스 형식으로 바꿔주는 마법사입니다.
RUN apk update && apk add --no-cache curl dos2unix

# --- 1. 호스트의 설정 파일 및 스크립트 '2개'를 모두 복사 ---
COPY ./nginx.conf /etc/nginx/nginx.conf.template
COPY ./transcode.sh /opt/scripts/transcode.sh
COPY ./generate_thumbnail.sh /opt/scripts/generate_thumbnail.sh

# --- 2. 컨테이너 내부 환경 설정 ---

# ✅ 스크립트 '2개'에 모두 실행 권한(+x)을 부여합니다.
RUN dos2unix /opt/scripts/transcode.sh && \
    dos2unix /opt/scripts/generate_thumbnail.sh && \
    chmod +x /opt/scripts/transcode.sh && \
    chmod +x /opt/scripts/generate_thumbnail.sh && \
    mkdir -p /opt/data/hls /opt/data/thumbnails && \
    chmod -R 777 /opt/data

# 포트 노출
EXPOSE 80
EXPOSE 1935