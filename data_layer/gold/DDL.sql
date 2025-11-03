-- Criação do esquema
CREATE SCHEMA IF NOT EXISTS dw;

-- ENUM's
CREATE TYPE dw.booking_status_enum AS ENUM (
    'No Driver Found', 
    'Incomplete', 
    'Completed', 
    'Cancelled by Driver', 
    'Cancelled by Customer'
);

CREATE TYPE dw.vehicle_type_enum AS ENUM (
    'eBike', 
    'Go Sedan', 
    'Auto', 
    'Premier Sedan', 
    'Bike', 
    'Go Mini', 
    'Uber XL'
);

CREATE TYPE dw.cancelled_by_enum AS ENUM (
    'customer', 
    'driver', 
    'none'
);

CREATE TYPE dw.cancellation_reason_enum AS ENUM (
    'Driver is not moving towards pickup location', 
    'Driver asked to cancel', 
    'AC is not working', 
    'Change of plans', 
    'Wrong Address', 
    'Personal & Car related issues', 
    'Customer related issue', 
    'More than permitted people in there', 
    'The customer was coughing/sick'
);

CREATE TYPE dw.incomplete_reason_enum AS ENUM (
    'Vehicle Breakdown', 
    'Other Issue', 
    'Customer Demand'
);

CREATE TYPE dw.payment_method_enum AS ENUM (
    'UPI', 
    'Debit Card', 
    'Cash', 
    'Uber Wallet', 
    'Credit Card'
);

-- tabelas

CREATE TABLE dw.dim_cus (
    srk_cus CHAR(10) NOT NULL,
    PRIMARY KEY (srk_cus)
);

CREATE TABLE dw.dim_pay (
    srk_pay CHAR(10) NOT NULL,
    payment_method dw.payment_method_enum,
    PRIMARY KEY (srk_pay)
);

CREATE TABLE dw.dim_veh (
    srk_veh CHAR(10) NOT NULL,
    vehicle_type dw.vehicle_type_enum,
    PRIMARY KEY (srk_veh)
);

CREATE TABLE dw.dim_loc (
    srk_loc UUID NOT NULL,
    drop_location VARCHAR(255),
    pickup_location VARCHAR(255),
    PRIMARY KEY (srk_loc)
);

CREATE TABLE dw.fat_rid (
    srk_rid CHAR(10) NOT NULL,
    
    srk_cus CHAR(10), 
    srk_veh CHAR(10),
    srk_pay CHAR(10),
    srk_loc UUID,
    
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
    
    PRIMARY KEY (srk_rid),
    
    FOREIGN KEY (srk_cus) REFERENCES dw.dim_cus (srk_cus),
    FOREIGN KEY (srk_veh) REFERENCES dw.dim_veh (srk_veh),
    FOREIGN KEY (srk_pay) REFERENCES dw.dim_pay (srk_pay),
    FOREIGN KEY (srk_loc) REFERENCES dw.dim_loc (srk_loc)
);

