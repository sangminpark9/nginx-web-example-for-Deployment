FROM nginx:stable-alpine

# 애플리케이션 파일을 /app에 복사
COPY src/ /app/
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# 엔트리포인트 스크립트 복사 및 실행 권한 부여
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 엔트리포인트 스크립트를 실행하여 동기화 후, nginx를 실행
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
