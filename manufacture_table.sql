-- manufacute 테이블 생성하는 쿼리 

use manufacture

-- 1. 관리자 저장 테이블 생성
CREATE TABLE register_info (
    rgst_id VARCHAR(255) PRIMARY KEY, -- 아이디
    rgst_pw VARCHAR(255), -- 비밀번호
    nickname VARCHAR(255), -- 이름
    crtd_dt VARCHAR(255), -- 등록일
    chgn_dt VARCHAR(255), -- 변경일자
    chgn_person VARCHAR(255) -- 변경자
);

-- 2. 이미지 테이블 생성
CREATE TABLE plt_img (
    plt_number INT AUTO_INCREMENT PRIMARY KEY, -- 파이프 이미지 번호 
    img LONGBLOB, -- 이미지 파일
    img_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 카메라에서 이미지 받은 시각
);

-- 3. 로그 정보 테이블 생성
CREATE TABLE log_info (
    log_id INT AUTO_INCREMENT PRIMARY KEY, -- 고유 ID 추가
    plt_number INT NOT NULL, -- 파이프 이미지 번호
    log_time DATETIME NOT NULL, -- 프론트에 띄워진 로그 시각 받는 화면
    ctgr VARCHAR(255) NOT NULL, -- 정상, 불량 판별 카테고리
    CONSTRAINT fk_loginfo_plt FOREIGN KEY (plt_number) REFERENCES plt_img(plt_number) ON DELETE CASCADE
);

-- 임시 쿼리 구문들 
ALTER TABLE log_info DROP FOREIGN KEY fk_loginfo_plt; -- 오류나면 foerign key 삭제해야 data 삭제가능해서 만든 임시 키
truncate table log_info; -- log_info 데이터만 지울때
drop table log_info; -- log_info 
check table plt_img; -- 테이블 존재 점검할 때
show processlist; -- dbeaver 사용하다가 과부하나 에러뜨면 kill 할 수 있는 process 찾는 쿼리
DROP TABLE IF EXISTS manufacture.plt_img; -- 테이블 삭제쿼리



-- 이미지 받을 때 조절하면 좋은 쿼리
show variables like 'max_allowed_packet'; 
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';

SET GLOBAL max_allowed_packet = 1073741824;  -- 1GB로 설정
SET GLOBAL innodb_buffer_pool_size = 2 * 1024 * 1024 * 1024;  -- 2GB 설정

-- db 받는 시간 확인할 때 점검하는 쿼리
select @@global.time_zone, @@session.time_zone;

Truncate table log_info;
use analysis;
truncate table plt_image_analysis;