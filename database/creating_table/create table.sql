---------------------------------------------------
-- 1. FARMERS TABLE
---------------------------------------------------
CREATE TABLE FARMERS (
    farmer_id      NUMBER         PRIMARY KEY,
    farmer_name    VARCHAR2(100)  NOT NULL,
    phone_number   VARCHAR2(20)   UNIQUE,
    location       VARCHAR2(100)  NOT NULL
);

-- Index for faster location-based queries
CREATE INDEX idx_farmers_location ON FARMERS(location);


---------------------------------------------------
-- 2. CROPS TABLE
---------------------------------------------------
CREATE TABLE CROPS (
    crop_id    NUMBER          PRIMARY KEY,
    crop_name  VARCHAR2(100)   NOT NULL UNIQUE,
    season     VARCHAR2(50)    NOT NULL
);

-- CHECK constraint for seasons (optional, example)
ALTER TABLE CROPS ADD CONSTRAINT chk_crop_season
CHECK (season IN ('Season A', 'Season B', 'Season C'));


---------------------------------------------------
-- 3. WEATHER_DATA TABLE
---------------------------------------------------
CREATE TABLE WEATHER_DATA (
    weather_id     NUMBER          PRIMARY KEY,
    location       VARCHAR2(100)   NOT NULL,
    reading_date   DATE            NOT NULL,
    temperature    NUMBER(5,2)     NOT NULL,
    rainfall       NUMBER(5,2)     NOT NULL CHECK (rainfall >= 0),
    humidity       NUMBER(5,2)     NOT NULL CHECK (humidity BETWEEN 0 AND 100)
);

-- Index for searching weather by location + date
CREATE INDEX idx_weather_loc_date 
ON WEATHER_DATA(location, reading_date);


---------------------------------------------------
-- 4. CROP_REQUIREMENTS TABLE
---------------------------------------------------
CREATE TABLE CROP_REQUIREMENTS (
    req_id         NUMBER         PRIMARY KEY,
    crop_id        NUMBER         NOT NULL,
    min_temp       NUMBER         NOT NULL,
    max_temp       NUMBER         NOT NULL,
    min_rainfall   NUMBER         NOT NULL,
    max_rainfall   NUMBER         NOT NULL,
    min_humidity   NUMBER         NOT NULL,
    max_humidity   NUMBER         NOT NULL,

    CONSTRAINT fk_req_crop 
        FOREIGN KEY (crop_id) REFERENCES CROPS(crop_id),

    CONSTRAINT chk_temp_range 
        CHECK (min_temp <= max_temp),

    CONSTRAINT chk_rainfall_range 
        CHECK (min_rainfall <= max_rainfall),

    CONSTRAINT chk_humidity_range 
        CHECK (min_humidity <= max_humidity AND max_humidity <= 100)
);

-- Index for crop requirement lookup
CREATE INDEX idx_cropreq_cropid ON CROP_REQUIREMENTS(crop_id);


---------------------------------------------------
-- 5. ADVISORY TABLE
---------------------------------------------------
CREATE TABLE ADVISORY (
    advisory_id       NUMBER           PRIMARY KEY,
    farmer_id         NUMBER           NOT NULL,
    crop_id           NUMBER           NOT NULL,
    weather_id        NUMBER           NOT NULL,
    advisory_message  VARCHAR2(500)    NOT NULL,
    advisory_date     DATE             DEFAULT SYSDATE,

    CONSTRAINT fk_adv_farmer 
        FOREIGN KEY (farmer_id) REFERENCES FARMERS(farmer_id),

    CONSTRAINT fk_adv_crop 
        FOREIGN KEY (crop_id) REFERENCES CROPS(crop_id),

    CONSTRAINT fk_adv_weather 
        FOREIGN KEY (weather_id) REFERENCES WEATHER_DATA(weather_id)
);

-- Index for farmer advisory search
CREATE INDEX idx_adv_farmer ON ADVISORY(farmer_id);

-- Index for weather-based advisory search
CREATE INDEX idx_adv_weather ON ADVISORY(weather_id);
