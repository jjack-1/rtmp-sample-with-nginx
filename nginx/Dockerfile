FROM tiangolo/nginx-rtmp


# 로컬에 있는 nginx.conf 파일을 컨테이너 내부의 /etc/nginx/nginx.conf 경로로 복사합니다.
COPY ./nginx.conf /etc/nginx/nginx.conf


# 컨테이너 빌드 시 실행될 명령어들입니다.
# '&& \' 를 사용하여 여러 명령어를 하나의 레이어에서 실행하면 이미지 용량이 최적화됩니다.
RUN apt-get update && \
    # 필수 패키지인 net-tools와 ffmpeg를 설치합니다 (-y 옵션으로 모든 프롬프트에 yes로 자동 응답).
    apt-get install -y net-tools ffmpeg && \
    # ------------------ [새로 추가된 부분 시작] ------------------
    # 1. HLS 세그먼트(.ts) 파일이 저장될 디렉토리를 생성합니다.
    #    -p 옵션은 상위 디렉토리가 없으면 함께 생성해줍니다.
    mkdir -p /tmp/hls && \
    # 2. FFmpeg의 작업/오류 로그를 기록할 빈 파일을 미리 생성합니다.
    touch /var/log/nginx/ffmpeg.log && \
    # 3. Nginx 프로세스(www-data 유저)가 위에서 만든 디렉토리와 파일에 쓸 수 있도록 소유권을 변경합니다.
    #    tiangolo/nginx-rtmp 이미지의 기본 유저는 'www-data'입니다.
    #    -R 옵션은 디렉토리 내부의 모든 파일과 하위 디렉토리에 대해 재귀적으로 적용됩니다.
    chown -R www-data:www-data /tmp/hls /var/log/nginx/ffmpeg.log && \
    # ------------------ [새로 추가된 부분 끝] --------------------
    # 설치 후 불필요한 apt 캐시를 삭제하여 최종 이미지의 크기를 줄입니다.
    rm -rf /var/lib/apt/lists/*


# 컨테이너가 외부와 통신할 포트를 지정합니다.
# 80: HTTP (HLS 파일 요청), 1935: RTMP (스트림 수신)
EXPOSE 80
EXPOSE 1935