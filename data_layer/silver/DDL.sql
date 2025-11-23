CREATE TYPE bkg_stt_enum AS ENUM (
    'No Driver Found', 'Incomplete', 'Completed', 
    'Cancelled by Driver', 'Cancelled by Customer'
);

CREATE TYPE ccd_by_enum AS ENUM (
    'customer', 'driver', 'none'
);

CREATE TYPE irr_enum AS ENUM (
    'Vehicle Breakdown', 'Other Issue', 'Customer Demand'
);

CREATE TYPE rfc_enum as ENUM (
		'Driver is not moving towards pickup location', 'Driver asked to cancel', 'AC is not working', 
    'Change of plans', 'Wrong Address', 'Personal & Car related issues', 'Customer related issue', 
    'More than permitted people in there', 'The customer was coughing/sick'
);

CREATE TABLE uber_silver (
	bkg_id CHAR(10) PRIMARY KEY,
	cus_id CHAR(10),
	bkg_vle INTEGER,
	drv_rtg FLOAT,
	cus_rtg FLOAT,
	rid_dis FLOAT,
	pay_mtd VARCHAR(20),
	dtt TIMESTAMP,
	veh_typ VARCHAR(20),
	pic_loc VARCHAR(255),
	drp_loc VARCHAR(255),
	avg_vtt FLOAT,
	avg_ctt FLOAT,
	ccd_by ccd_by_enum,
	rfc rfc_enum,
	bkg_stt bkg_stt_enum,
	irr irr_enum
);
