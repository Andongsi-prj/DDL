-- supeset 시각화 위한 2025-02-01 ~ 2025-02-28 정상,불량 데이터 생성 쿼리

USE manufacture;

DROP PROCEDURE IF EXISTS manufacture.generate_manufacture_data;

DELIMITER $$

CREATE PROCEDURE manufacture.generate_manufacture_data()
BEGIN
    DECLARE start_date DATE;
    DECLARE end_date DATE;
    DECLARE cur_date DATE;  
    DECLARE total_pipes INT;
    DECLARE defect_pipes INT;
    DECLARE counter INT;
    DECLARE log_time TIME;
    DECLARE defect_positions VARCHAR(5000);
    DECLARE temp_position INT;
    DECLARE defect_rate DECIMAL(5,2);

    SET start_date = '2025-02-01';
    SET end_date = '2025-02-28';
    SET cur_date = start_date;

    WHILE cur_date <= end_date DO
        -- 주말(토,일) 제외
        IF DAYOFWEEK(cur_date) NOT IN (1, 7) THEN
            -- 테이블 이름 설정
            SET @table_name = CONCAT('manufacture_', DATE_FORMAT(cur_date, '%Y_%m_%d'));

            -- 테이블 생성 SQL
            SET @create_table_sql = CONCAT(
                'CREATE TABLE IF NOT EXISTS ', @table_name, ' (',
                'plt_number INT AUTO_INCREMENT PRIMARY KEY, ',
                'log_date DATE NOT NULL, ',
                'log_time TIME NOT NULL, ',
                'ctgr ENUM("Normal", "Defect") NOT NULL ',
                ') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;'
            );

            -- 테이블 생성 실행
            PREPARE stmt FROM @create_table_sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            -- 총 검사 개수 (1518개)
            SET total_pipes = 1518;

            -- 날짜별 불량률 설정 (1% ~ 5% 랜덤 변동)
            SET defect_rate = ROUND(1 + RAND() * 4, 2);  -- 1% ~ 5% 사이의 랜덤 불량률
            SET defect_pipes = FLOOR(total_pipes * defect_rate / 100);
            SET counter = 1;
            SET log_time = '16:30:00';

            -- 불량 위치 무작위 선택
            SET defect_positions = '';
            WHILE LENGTH(defect_positions) < defect_pipes * 3 DO
                SET temp_position = FLOOR(RAND() * total_pipes) + 1;
                IF FIND_IN_SET(temp_position, defect_positions) = 0 THEN
                    SET defect_positions = CONCAT(defect_positions, ',', temp_position);
                END IF;
            END WHILE;

            -- 데이터 삽입
            WHILE counter <= total_pipes DO
                -- 랜덤하게 불량 배치
                IF FIND_IN_SET(counter, defect_positions) > 0 THEN
                    SET @category = 'Defect';
                ELSE
                    SET @category = 'Normal';
                END IF;

                -- 데이터 삽입 SQL
                SET @insert_sql = CONCAT(
                    'INSERT INTO ', @table_name, ' (log_date, log_time, ctgr) VALUES (',
                    '"', cur_date, '", "', log_time, '", "', @category, '");'
                );

                PREPARE stmt FROM @insert_sql;
                EXECUTE stmt;
                DEALLOCATE PREPARE stmt;

                -- 5초 간격 시간 증가
                SET log_time = ADDTIME(log_time, '00:00:05');
                SET counter = counter + 1;
            END WHILE;
        END IF;

        -- 다음 날짜로 이동
        SET cur_date = DATE_ADD(cur_date, INTERVAL 1 DAY);
    END WHILE;
END;

DELIMITER ;

# 생성 코드 
CALL manufacture.generate_manufacture_data();

-- 불량률 테이블 생성
CREATE TABLE IF NOT EXISTS manufacture.daily_defect_rate (
    log_date DATE PRIMARY KEY,  -- 날짜 (YYYY-MM-DD)
    week_number INT,  -- 주차 (1, 2, 3, 4 형태로 저장)
    defect_count INT,  -- 불량 개수
    total_count INT,  -- 총 검사 개수
    defect_rate DECIMAL(5,2)  -- 불량률 (%)
);


-- 테이블에 값 입력
INSERT INTO manufacture.daily_defect_rate (log_date, week_number, defect_count, total_count, defect_rate)
SELECT 
    log_date, 
    DENSE_RANK() OVER (ORDER BY YEARWEEK(log_date, 1)) AS week_number,  
    COUNT(CASE WHEN ctgr = 'Defect' THEN 1 END) AS defect_count,  
    COUNT(*) AS total_count,  
    ROUND((COUNT(CASE WHEN ctgr = 'Defect' THEN 1 END) / COUNT(*)) * 100, 2) AS defect_rate  
FROM (
    SELECT log_date, ctgr FROM manufacture_2025_02_03
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_04
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_05
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_06
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_07
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_10
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_11
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_12
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_13
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_14
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_17
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_18
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_19
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_20
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_21
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_24
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_25
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_26
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_27
    UNION ALL SELECT log_date, ctgr FROM manufacture_2025_02_28
) AS combined_data
GROUP BY log_date
ON DUPLICATE KEY UPDATE 
    week_number = VALUES(week_number),
    defect_count = VALUES(defect_count),
    total_count = VALUES(total_count),
    defect_rate = VALUES(defect_rate);

-- weekly_defect_rate 테이블 만들기
CREATE TABLE IF NOT EXISTS manufacture.weekly_defect_rate AS
SELECT 
    week_number,
    ROUND(AVG(defect_rate), 2) AS avg_defect_rate
FROM manufacture.daily_defect_rate
GROUP BY week_number;

SELECT DATE_FORMAT(log_date, '%Y-%m-%d') AS log_date, defect_count, defect_rate
FROM manufacture.daily_defect_rate
ORDER BY log_date ASC;


