FROM alfg/nginx-rtmp

# 1. 위에서 만든 진단용 nginx.conf 파일을 복사합니다.
COPY ./nginx.conf /etc/nginx/nginx.conf.template

# 2. 로그 파일이 저장될 디렉토리를 만들고 쓰기 권한을 줍니다.
RUN mkdir -p /opt/data && chmod -R 777 /opt/data

EXPOSE 80
EXPOSE 1935