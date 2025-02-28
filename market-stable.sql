-- 시장전망지표, 수급안정화지수 저장하는 테이블 market_stable 테이블 생성 쿼리

use analysis;

CREATE TABLE market_stable (
    record_date DATE PRIMARY KEY,  -- 날짜를 기본 키로 설정 (고유 값)
    aluminum_market_index DECIMAL(10,2),
    chrome_market_index DECIMAL(10,2),
    silicon_market_index DECIMAL(10,2),
    coal_market_index DECIMAL(10,2),
    iron_market_index DECIMAL(10,2),
    aluminum_supply_stability DECIMAL(10,2),
    chrome_supply_stability DECIMAL(10,2),
    silicon_supply_stability DECIMAL(10,2),
    coal_supply_stability DECIMAL(10,2) NULL,  -- 2025년 3월 이후 예측값 추가
    iron_supply_stability DECIMAL(10,2) NULL   -- 2025년 3월 이후 예측값 추가
);

-- market_stable_predict 테이블 생성 쿼리

CREATE TABLE market_stable_predict (
    record_date DATE PRIMARY KEY,  -- 날짜를 기본 키로 설정 (고유 값)
    aluminum_market_index DECIMAL(10,2),
    chrome_market_index DECIMAL(10,2),
    silicon_market_index DECIMAL(10,2),
    coal_market_index DECIMAL(10,2),
    iron_market_index DECIMAL(10,2),
    aluminum_supply_stability DECIMAL(10,2),
    chrome_supply_stability DECIMAL(10,2),
    silicon_supply_stability DECIMAL(10,2),
    coal_supply_stability DECIMAL(10,2) NULL,  -- 2025년 3월 이후 예측값 추가
    iron_supply_stability DECIMAL(10,2) NULL   -- 2025년 3월 이후 예측값 추가
);