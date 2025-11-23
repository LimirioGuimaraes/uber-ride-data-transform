CREATE SCHEMA IF NOT EXISTS dw;

-- ETAPA 1: ENUM's

CREATE TYPE dw.bkg_stt_enum AS ENUM (
    'No Driver Found', 'Incomplete', 'Completed', 
    'Cancelled by Driver', 'Cancelled by Customer'
);

CREATE TYPE dw.ccd_by_enum AS ENUM (
    'customer', 'driver', 'none'
);

CREATE TYPE dw.rfc_enum AS ENUM (
    'Driver is not moving towards pickup location', 'Driver asked to cancel', 
    'AC is not working', 'Change of plans', 'Wrong Address', 
    'Personal & Car related issues', 'Customer related issue', 
    'More than permitted people in there', 'The customer was coughing/sick'
);

CREATE TYPE dw.irr_enum AS ENUM (
    'Vehicle Breakdown', 'Other Issue', 'Customer Demand'
);

-- ETAPA 2: Tabelas de Dimensão

CREATE TABLE dw.dim_cus (
    srk_cus SERIAL PRIMARY KEY,
    cus_id VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE dw.dim_pay (
    srk_pay SERIAL PRIMARY KEY,
    pay_mtd VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE dw.dim_veh (
    srk_veh SERIAL PRIMARY KEY,
    veh_typ VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE dw.dim_loc (
    srk_loc SERIAL PRIMARY KEY,
    drp_loc VARCHAR(255),
    pic_loc VARCHAR(255),
    UNIQUE(drp_loc, pic_loc)
);

CREATE TABLE dw.dim_dat (
    srk_dat INTEGER PRIMARY KEY, 
    
    fll_dat DATE NOT NULL UNIQUE,
    day_nme VARCHAR(10) NOT NULL,
    day_wek INTEGER NOT NULL,
    day_mth INTEGER NOT NULL,
    day_yea INTEGER NOT NULL,
    mth_nme VARCHAR(20) NOT NULL,
    mth_nbr INTEGER NOT NULL,
    qtr_nbr INTEGER NOT NULL,
    yea_nbr INTEGER NOT NULL,
    is_wkd BOOLEAN NOT NULL,
    is_hol BOOLEAN NOT NULL DEFAULT FALSE
);

-- ETAPA 2.1: Semeadura
INSERT INTO dw.dim_cus (cus_id) 
VALUES ('N/A')
ON CONFLICT (cus_id) DO NOTHING;

INSERT INTO dw.dim_pay (pay_mtd) 
VALUES ('N/A')
ON CONFLICT (pay_mtd) DO NOTHING;

INSERT INTO dw.dim_veh (veh_typ) 
VALUES ('N/A')
ON CONFLICT (veh_typ) DO NOTHING;

INSERT INTO dw.dim_loc (drp_loc, pic_loc) 
VALUES ('N/A', 'N/A')
ON CONFLICT (drp_loc, pic_loc) DO NOTHING;

INSERT INTO dw.dim_dat (
    srk_dat, fll_dat, day_nme, day_wek, day_mth, 
    day_yea, mth_nme, mth_nbr, qtr_nbr, 
    yea_nbr, is_wkd, is_hol
)
VALUES (
    -1, '1900-01-01', 'N/A', 0, 0, 0, 'N/A', 0, 0, 0, false, false
)
ON CONFLICT (srk_dat) DO NOTHING;

-- ETAPA 3: Tabela Fato 

CREATE TABLE dw.fat_rid (
    srk_rid SERIAL PRIMARY KEY,
    
    srk_cus INTEGER NOT NULL, 
    srk_veh INTEGER NOT NULL,
    srk_pay INTEGER NOT NULL,
    srk_loc INTEGER NOT NULL,
    srk_dat INTEGER NOT NULL, 
    
    dtt TIMESTAMP, 
    bkg_stt dw.bkg_stt_enum,
    avg_vtt FLOAT,
    avg_ctt FLOAT,
    ccd_by dw.ccd_by_enum,
    rfc dw.rfc_enum,
    irr dw.irr_enum,
    bkg_vle INTEGER,
    rid_dis FLOAT,
    drv_rtg FLOAT,
    cus_rtg FLOAT, 
    
    FOREIGN KEY (srk_cus) REFERENCES dw.dim_cus (srk_cus),
    FOREIGN KEY (srk_veh) REFERENCES dw.dim_veh (srk_veh),
    FOREIGN KEY (srk_pay) REFERENCES dw.dim_pay (srk_pay),
    FOREIGN KEY (srk_loc) REFERENCES dw.dim_loc (srk_loc),
    FOREIGN KEY (srk_dat) REFERENCES dw.dim_dat (srk_dat)
);


-- ETAPA 4: Índices 
CREATE INDEX idx_fat_rid_srk_cus 	ON dw.fat_rid(srk_cus);
CREATE INDEX idx_fat_rid_srk_veh 	ON dw.fat_rid(srk_veh);
CREATE INDEX idx_fat_rid_srk_pay 	ON dw.fat_rid(srk_pay);
CREATE INDEX idx_fat_rid_srk_loc 	ON dw.fat_rid(srk_loc);
CREATE INDEX idx_fat_rid_srk_dat 	ON dw.fat_rid(srk_dat); 
CREATE INDEX idx_fat_rid_dtt 			ON dw.fat_rid(dtt);
