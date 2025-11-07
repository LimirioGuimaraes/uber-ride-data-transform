CREATE SCHEMA IF NOT EXISTS dw;

-- ETAPA 1: ENUM's

CREATE TYPE dw.booking_status_enum AS ENUM (
    'No Driver Found', 'Incomplete', 'Completed', 
    'Cancelled by Driver', 'Cancelled by Customer'
);

CREATE TYPE dw.cancelled_by_enum AS ENUM (
    'customer', 'driver', 'none'
);

CREATE TYPE dw.cancellation_reason_enum AS ENUM (
    'Driver is not moving towards pickup location', 'Driver asked to cancel', 
    'AC is not working', 'Change of plans', 'Wrong Address', 
    'Personal & Car related issues', 'Customer related issue', 
    'More than permitted people in there', 'The customer was coughing/sick'
);

CREATE TYPE dw.incomplete_reason_enum AS ENUM (
    'Vehicle Breakdown', 'Other Issue', 'Customer Demand'
);

-- ETAPA 2: Tabelas de Dimensão

CREATE TABLE dw.dim_cus (
    srk_cus SERIAL PRIMARY KEY,
    customer_id VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE dw.dim_pay (
    srk_pay SERIAL PRIMARY KEY,
    payment_method VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE dw.dim_veh (
    srk_veh SERIAL PRIMARY KEY,
    vehicle_type VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE dw.dim_loc (
    srk_loc SERIAL PRIMARY KEY,
    drop_location VARCHAR(255),
    pickup_location VARCHAR(255),
    UNIQUE(drop_location, pickup_location)
);

CREATE TABLE dw.dim_date (
    srk_date INTEGER PRIMARY KEY, 
    
    full_date DATE NOT NULL UNIQUE,
    day_name VARCHAR(10) NOT NULL,
    day_of_week INTEGER NOT NULL,
    day_of_month INTEGER NOT NULL,
    day_of_year INTEGER NOT NULL,
    month_name VARCHAR(20) NOT NULL,
    month_number INTEGER NOT NULL,
    quarter_number INTEGER NOT NULL,
    year_number INTEGER NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    is_holiday BOOLEAN NOT NULL DEFAULT FALSE
);

-- ETAPA 2.1: Semeadura
INSERT INTO dw.dim_cus (customer_id) 
VALUES ('N/A')
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO dw.dim_pay (payment_method) 
VALUES ('N/A')
ON CONFLICT (payment_method) DO NOTHING;

INSERT INTO dw.dim_veh (vehicle_type) 
VALUES ('N/A')
ON CONFLICT (vehicle_type) DO NOTHING;

INSERT INTO dw.dim_loc (drop_location, pickup_location) 
VALUES ('N/A', 'N/A')
ON CONFLICT (drop_location, pickup_location) DO NOTHING;

INSERT INTO dw.dim_date (
    srk_date, full_date, day_name, day_of_week, day_of_month, 
    day_of_year, month_name, month_number, quarter_number, 
    year_number, is_weekend, is_holiday
)
VALUES (
    -1, '1900-01-01', 'N/A', 0, 0, 0, 'N/A', 0, 0, 0, false, false
)
ON CONFLICT (srk_date) DO NOTHING;

-- ETAPA 3: Tabela Fato 

CREATE TABLE dw.fat_rid (
    srk_rid SERIAL PRIMARY KEY,
    
    srk_cus INTEGER NOT NULL, 
    srk_veh INTEGER NOT NULL,
    srk_pay INTEGER NOT NULL,
    srk_loc INTEGER NOT NULL,
    srk_date INTEGER NOT NULL, 
    
    date_time TIMESTAMP, 
    booking_status dw.booking_status_enum,
    avg_vtat FLOAT,
    avg_ctat FLOAT,
    cancelled_by dw.cancelled_by_enum,
    reason_for_cancelling dw.cancellation_reason_enum,
    incomplete_rides_reason dw.incomplete_reason_enum,
    booking_value INTEGER,
    ride_distance FLOAT,
    driver_rating FLOAT,
    customer_rating FLOAT, 
    
    FOREIGN KEY (srk_cus) REFERENCES dw.dim_cus (srk_cus),
    FOREIGN KEY (srk_veh) REFERENCES dw.dim_veh (srk_veh),
    FOREIGN KEY (srk_pay) REFERENCES dw.dim_pay (srk_pay),
    FOREIGN KEY (srk_loc) REFERENCES dw.dim_loc (srk_loc),
    FOREIGN KEY (srk_date) REFERENCES dw.dim_date (srk_date)
);


-- ETAPA 4: Índices 
CREATE INDEX idx_fat_rid_srk_cus ON dw.fat_rid(srk_cus);
CREATE INDEX idx_fat_rid_srk_veh ON dw.fat_rid(srk_veh);
CREATE INDEX idx_fat_rid_srk_pay ON dw.fat_rid(srk_pay);
CREATE INDEX idx_fat_rid_srk_loc ON dw.fat_rid(srk_loc);
CREATE INDEX idx_fat_rid_srk_date ON dw.fat_rid(srk_date); 
CREATE INDEX idx_fat_rid_date_time ON dw.fat_rid(date_time);