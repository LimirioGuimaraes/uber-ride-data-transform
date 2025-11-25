CREATE TYPE booking_status_enum AS ENUM (
    'No Driver Found', 'Incomplete', 'Completed', 
    'Cancelled by Driver', 'Cancelled by Customer'
);

CREATE TYPE cancelled_by_enum AS ENUM (
    'customer', 'driver', 'none'
);

CREATE TYPE incomplete_ride_reason_enum AS ENUM (
    'Vehicle Breakdown', 'Other Issue', 'Customer Demand'
);

CREATE TYPE reason_for_cancelling_enum as ENUM (
		'Driver is not moving towards pickup location', 'Driver asked to cancel', 'AC is not working', 
    'Change of plans', 'Wrong Address', 'Personal & Car related issues', 'Customer related issue', 
    'More than permitted people in there', 'The customer was coughing/sick'
);

CREATE TABLE uber_silver (
    booking_id CHAR(10) PRIMARY KEY,              
    customer_id CHAR(10),                         
    booking_value INTEGER,                        
    driver_rating FLOAT,                          
    customer_rating FLOAT,                        
    ride_distance FLOAT,                          
    payment_method VARCHAR(20),                   
    date_time TIMESTAMP,                          
    vehicle_type VARCHAR(20),                     
    pickup_location VARCHAR(255),                 
    drop_location VARCHAR(255),                   
    avg_vtat FLOAT,                               
    avg_ctat FLOAT,                               
    cancelled_by cancelled_by_enum,                     
    reason_for_cancelling reason_for_cancelling_enum,               
    booking_status booking_status_enum, 
    incomplete_ride_reason incomplete_ride_reason_enum 
);
