FROM nginx:stable-alpine

# rsync 설치 (Alpine 기준)
RUN apk update && apk add rsync

# 웹 애플리케이션 파일 복사
COPY src/ /app/

# nginx 설정 파일 복사
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# entrypoint 스크립트 복사 및 실행 권한 부여
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 엔트리포인트와 CMD 설정
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
