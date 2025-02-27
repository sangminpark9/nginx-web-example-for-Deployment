#!/bin/sh
echo "동기화 작업 시작: /app -> /usr/share/nginx/html"
/*
   /app 디렉터리는 Dockerfile에서 복사한 최신 웹 파일들이 위치하는 곳입니다.
   /usr/share/nginx/html은 nginx가 서비스하는 디렉터리로, 볼륨 마운트가 되어 있다 하더라도
   이 엔트리포인트에서 동기화하면 최신 내용으로 덮어쓰게 됩니다.
*/
rsync -av --delete /app/ /usr/share/nginx/html/
echo "동기화 완료. nginx 시작..."
# 전달받은 명령어(예: nginx 실행)를 실행
exec "$@"

