-- superset 시각화 위한 daily_defect_pie 테이블 만들기

CREATE TABLE IF NOT EXISTS manufacture.daily_defect_pie (
    log_date DATE,          -- 날짜
    category ENUM('Normal', 'Defect'),  -- 정상 / 불량
    count_value INT,        -- 개수
    PRIMARY KEY (log_date, category)
);

-- 데이터 삽입 (중복 방지)
INSERT INTO manufacture.daily_defect_pie (log_date, category, count_value)
SELECT 
    log_date, 
    'Defect' AS category,  -- 불량 데이터
    defect_count AS count_value
FROM manufacture.daily_defect_rate

UNION ALL

SELECT 
    log_date,
    'Normal' AS category,  -- 정상 데이터
    (total_count - defect_count) AS count_value
FROM manufacture.daily_defect_rate
ON DUPLICATE KEY UPDATE count_value = VALUES(count_value);
