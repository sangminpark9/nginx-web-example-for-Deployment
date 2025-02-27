FROM nginx:stable-alpine

# 1. 웹 애플리케이션 파일을 /app에 복사합니다.
COPY src/ /app/

# 2. 필요한 nginx 설정 파일 복사 (필요에 따라 수정)
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# 3. entrypoint 스크립트를 컨테이너에 복사하고 실행 권한을 부여합니다.
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 4. entrypoint 스크립트를 엔트리포인트로 설정하고, 기본 CMD로 nginx 실행
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
