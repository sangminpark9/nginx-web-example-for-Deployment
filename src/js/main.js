document.addEventListener('DOMContentLoaded', function() {
    // DOM 요소
    const buildNumber = document.getElementById('build-number');
    const buildTime = document.getElementById('build-time');
    const buildStatus = document.getElementById('build-status');
    const refreshBtn = document.getElementById('refresh-btn');
    
    // 현재 시간으로 빌드 시간 업데이트
    function updateBuildTime() {
        const now = new Date();
        
        // 한국 시간 형식으로 포맷팅
        const options = { 
            year: 'numeric', 
            month: '2-digit', 
            day: '2-digit', 
            hour: '2-digit', 
            minute: '2-digit', 
            second: '2-digit',
            hour12: false
        };
        
        buildTime.textContent = now.toLocaleString('ko-KR', options);
    }
    
    // 빌드 상태 랜덤 업데이트 (데모용)
    function updateBuildStatus() {
        // 빌드 번호 증가
        const currentNumber = parseInt(buildNumber.textContent, 10);
        buildNumber.textContent = currentNumber + 1;
        
        // 현재 시간으로 업데이트
        updateBuildTime();
        
        // 실제로는 Jenkins API에서 상태를 가져올 것입니다
        // 여기서는 데모를 위해 랜덤하게 성공/실패 설정
        const isSuccess = Math.random() > 0.2; // 80% 확률로 성공
        
        if (isSuccess) {
            buildStatus.textContent = '성공';
            buildStatus.className = 'status-success';
        } else {
            buildStatus.textContent = '실패';
            buildStatus.className = 'status-failure';
        }
    }
    
    // 새로고침 버튼에 이벤트 리스너 추가
    refreshBtn.addEventListener('click', updateBuildStatus);
    
    // 환경 정보 콘솔에 출력 (개발용)
    console.log('CI/CD 데모 웹사이트가 로드되었습니다');
    console.log('빌드 날짜: ' + buildTime.textContent);
});
