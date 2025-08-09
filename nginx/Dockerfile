# alfg/nginx-rtmp 이미지 사용 (ffmpeg 내장)
FROM alfg/nginx-rtmp

# 커스텀 nginx.conf 설정 파일 복사
# 이 경로는 Entrypoint 스크립트가 사용하는 경로여야 합니다.
COPY ./nginx.conf /etc/nginx/nginx.conf.template

# HLS 세그먼트 저장 디렉토리 생성
RUN mkdir -p /opt/data/hls

# 포트 노출
EXPOSE 80
EXPOSE 1935