use analysis;
''' -- 이미지를 텍스트 형태로 받을 때 사용하는 쿼리 
CREATE TABLE plt_image_analysis (
    analysis_id INT AUTO_INCREMENT PRIMARY KEY,  -- 자동 증가 및 기본 키
    plt_number INT NOT NULL,                     -- 플레이트 번호 (NULL 허용 X)
    img MEDIUMTEXT,                              -- Base64로 저장될 이미지
    log_time DATETIME,                           -- 분석된 시각
    ctgr VARCHAR(255)                            -- 분석 결과 (normal, defect 등)
);'''

-- 분석계에서 이미지 받을 때 사용하는 테이블 생성하는 쿼리 
CREATE TABLE plt_image_analysis (
    analysis_id INT AUTO_INCREMENT PRIMARY KEY,  -- 자동 증가 및 기본 키
    plt_number INT NOT NULL,                     -- 플레이트 번호 (NULL 허용 X)
    img LONGBLOB,                              -- LONGBLOB
    log_time DATETIME,                           -- 분석된 시각
    ctgr VARCHAR(255)                            -- 분석 결과 (normal, defect 등)
);
