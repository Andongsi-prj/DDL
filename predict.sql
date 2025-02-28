-- predict_car_market table

use analysis;

-- 자동차 예측 테이블 생성 쿼리
CREATE TABLE dm_car_predict (
    dm_id INT AUTO_INCREMENT PRIMARY KEY,
    record_month DATE NOT NULL,  -- 월별 기준 (YYYY-MM-01 형식)

    -- 원자재 가격 (철광석, 알루미늄, 크롬, 유연탄)
    iron_price DECIMAL(10,2),
    aluminum_price DECIMAL(10,2),
    chrome_price DECIMAL(10,2),
    coal_price DECIMAL(10,2),

    -- 완제품(자동차) 가격
    car_price DECIMAL(10,2),

    -- 10개 기업 주가
    posco_price DECIMAL(10,2),
    hyundai_steel_price DECIMAL(10,2),
    seah_steel_price DECIMAL(10,2),
    korea_steel_price DECIMAL(10,2),
    dongkuk_steel_price DECIMAL(10,2),
    daehan_steel_price DECIMAL(10,2),
    kg_steel_price DECIMAL(10,2),
    tcc_steel_price DECIMAL(10,2),
    kisco_price DECIMAL(10,2),
    hankuk_steel_price DECIMAL(10,2),

    -- 환율
    exchange_rate DECIMAL(10,4),

    -- 뉴스 감성 분석 점수 (월간 평균)
    steel_news_score DECIMAL(5,2),
    raw_material_news_score DECIMAL(5,2)
);

-- 램 가격 예측 테이블
CREATE TABLE dm_ram_predict (
    dm_id INT AUTO_INCREMENT PRIMARY KEY,
    record_month DATE NOT NULL,  -- 월별 기준 (YYYY-MM-01 형식)

    -- 원자재 가격 (실리콘)
    silicon_price DECIMAL(10,2),

    -- 완제품(RAM) 가격 (회사명 + DDR 버전)
    SKHynix_DDR5_price DECIMAL(10,2),
    Samsung_DDR5_price DECIMAL(10,2),
    ESSENCORE_KLEVV_DDR5_price DECIMAL(10,2),
    TeamGroup_TCREATE_DDR5_price DECIMAL(10,2),
    Samsung_DDR4_price DECIMAL(10,2),
    ESSENCORE_KLEVV_DDR4_price DECIMAL(10,2),
    Micron_Crucial_DDR4_price DECIMAL(10,2),

    -- 환율
    exchange_rate DECIMAL(10,4),

    -- 뉴스 감성 분석 점수 (월간 평균)
    ram_news_score DECIMAL(5,2),
    raw_material_news_score DECIMAL(5,2)
);

-- 자동차 예측 데이터 입력
INSERT INTO dm_car_predict (
    record_month, 
    iron_price, aluminum_price, chrome_price, coal_price, 
    car_price, 
    exchange_rate,
    posco_price, hyundai_steel_price, seah_steel_price, korea_steel_price, dongkuk_steel_price,
    daehan_steel_price, kg_steel_price, tcc_steel_price, kisco_price, hankuk_steel_price,
    steel_news_score, raw_material_news_score
)
SELECT 
    record_month, iron_price, aluminum_price, chrome_price, coal_price, 
    car_price, exchange_rate,
    posco_price, hyundai_steel_price, seah_steel_price, korea_steel_price, dongkuk_steel_price,
    daehan_steel_price, kg_steel_price, tcc_steel_price, kisco_price, hankuk_steel_price,
    steel_news_score, raw_material_news_score
FROM dm_car_market
ORDER BY record_month;

-- ram 예측 데이터 입력
INSERT INTO dm_ram_predict (
    record_month, 
    silicon_price, 
    SKHynix_DDR5_price, Samsung_DDR5_price, ESSENCORE_KLEVV_DDR5_price, TeamGroup_TCREATE_DDR5_price,
    Samsung_DDR4_price, ESSENCORE_KLEVV_DDR4_price, Micron_Crucial_DDR4_price,
    exchange_rate,
    ram_news_score, raw_material_news_score
)
SELECT 
    record_month, silicon_price, 
    SKHynix_DDR5_price, Samsung_DDR5_price, ESSENCORE_KLEVV_DDR5_price, TeamGroup_TCREATE_DDR5_price,
    Samsung_DDR4_price, ESSENCORE_KLEVV_DDR4_price, Micron_Crucial_DDR4_price,
    exchange_rate,
    ram_news_score, raw_material_news_score
FROM dm_ram_market
ORDER BY record_month;

