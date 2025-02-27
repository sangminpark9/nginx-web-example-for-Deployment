pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'nginx-web-example'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        REMOTE_HOST = 'ec2-user@10.0.2.208'
        REMOTE_DIR = '/home/ec2-user/nginx-app'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                // 빌드 시간과 번호 업데이트
                script {
                    def buildTime = new Date().format("yyyy-MM-dd HH:mm:ss", TimeZone.getTimeZone('Asia/Seoul'))
                    sh "sed -i 's|빌드 시간: <span id=\"build-time\">[^<]*</span>|빌드 시간: <span id=\"build-time\">${buildTime}</span>|g' src/index.html"
                    sh "sed -i 's|빌드 번호: <span id=\"build-number\">[^<]*</span>|빌드 번호: <span id=\"build-number\">${env.BUILD_NUMBER}</span>|g' src/index.html"
                }
                
                // Docker 이미지 빌드
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
                sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest"
                
                // 이미지 저장 (웹 서버로 전송용)
                sh "docker save ${DOCKER_IMAGE}:latest | gzip > ${DOCKER_IMAGE}.tar.gz"
            }
        }
        
        stage('Test') {
            steps {
                // 이전 테스트 컨테이너 정리
                sh 'docker ps -a -q --filter name=test-nginx-web-example | xargs -r docker rm -f || true'
                
                // 테스트용 컨테이너 실행
                sh "docker run -d --name test-nginx-web-example -p 8888:80 ${DOCKER_IMAGE}:${DOCKER_TAG}"
                
                // 컨테이너 시작 대기
                sh 'sleep 5'
                
                // HTTP 응답 테스트
                sh 'docker exec test-nginx-web-example curl -s -o /dev/null -w "%{http_code}" http://localhost:80 | grep 200'
                
                // 테스트 컨테이너 정리
                sh 'docker stop test-nginx-web-example && docker rm test-nginx-web-example'
            }
        }
        
        stage('Deploy') {
            steps {
                sshagent(['jkwebkey-jk']) {
                    // 원격 디렉토리 생성
                    sh "ssh -o StrictHostKeyChecking=no ${REMOTE_HOST} 'mkdir -p ${REMOTE_DIR}'"
                    
                    // Docker 이미지 전송
                    sh "scp -o StrictHostKeyChecking=no ${DOCKER_IMAGE}.tar.gz ${REMOTE_HOST}:${REMOTE_DIR}/"
                    
                    // docker-compose.yml 파일 전송
                    sh "scp -o StrictHostKeyChecking=no docker-compose.yml ${REMOTE_HOST}:${REMOTE_DIR}/"
                    
                    // 원격 서버에서 이미지 로드 및 컨테이너 재시작
                    sh """
                        ssh -o StrictHostKeyChecking=no ${REMOTE_HOST} '
                            cd ${REMOTE_DIR}
                            docker load < ${DOCKER_IMAGE}.tar.gz
                            docker-compose down
                            docker-compose up -d
                            rm ${DOCKER_IMAGE}.tar.gz
                        '
                    """
                }
            }
        }
    }
    
    post {
        always {
            // 작업 공간 정리
            cleanWs()
        }
        success {
            echo '파이프라인이 성공적으로 완료되었습니다!'
        }
        failure {
            echo '파이프라인 실행 중 오류가 발생했습니다.'
        }
    }
}
