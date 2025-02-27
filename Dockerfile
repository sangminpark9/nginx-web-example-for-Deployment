FROM nginx:stable-alpine

# 기본 Nginx 설정 제거
RUN rm -rf /usr/share/nginx/html/*

# 소스 코드를 컨테이너에 복사
COPY src/ /usr/share/nginx/html/
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# 포트 노출
EXPOSE 80

# Nginx 시작
CMD ["nginx", "-g", "daemon off;"]w
