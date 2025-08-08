FROM tiangolo/nginx-rtmp

COPY ./nginx.conf /etc/nginx/nginx.conf

# 패키지 목록을 업데이트하고, net-tools와 ffmpeg를 한 번에 설치합니다.
# 설치 후 apt 캐시를 제거하여 이미지 크기를 최적화합니다.
RUN apt update && \
    apt install -y net-tools ffmpeg && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 80