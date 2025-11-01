-- ==========================================================
--  New York EHR Discharges (SPARCS 2023)
--  Full MySQL Load + Clean Script
--  Author: <you>
-- ==========================================================

-- ----------------------------------------------------------
-- 1.  Create database and use it
-- ----------------------------------------------------------
CREATE DATABASE IF NOT EXISTS ehr_new_york_discharges;
USE ehr_new_york_discharges;

-- ----------------------------------------------------------
-- 2.  Drop and recreate staging table
-- ----------------------------------------------------------
DROP TABLE IF EXISTS discharges_raw;
CREATE TABLE discharges_raw (
    `Hospital Service Area`                VARCHAR(255),
    `Hospital County`                      VARCHAR(255),
    `Operating Certificate Number`         DOUBLE,
    `Permanent Facility Id`                DOUBLE,
    `Facility Name`                        VARCHAR(255),
    `Age Group`                            VARCHAR(50),
    `Zip Code - 3 digits`                  CHAR(3),
    `Gender`                               VARCHAR(20),
    `Race`                                 VARCHAR(100),
    `Ethnicity`                            VARCHAR(100),
    `Length of Stay`                       INT,
    `Type of Admission`                    VARCHAR(50),
    `Patient Disposition`                  VARCHAR(100),
    `Discharge Year`                       INT,
    `CCSR Diagnosis Code`                  VARCHAR(50),
    `CCSR Diagnosis Description`           VARCHAR(255),
    `CCSR Procedure Code`                  VARCHAR(50),
    `CCSR Procedure Description`           VARCHAR(255),
    `APR DRG Code`                         INT,
    `APR DRG Description`                  VARCHAR(255),
    `APR MDC Code`                         INT,
    `APR MDC Description`                  VARCHAR(255),
    `APR Severity of Illness Code`         INT,
    `APR Severity of Illness Description`  VARCHAR(255),
    `APR Risk of Mortality`                VARCHAR(50),
    `APR Medical Surgical Description`     VARCHAR(50),
    `Payment Typology 1`                   VARCHAR(100),
    `Payment Typology 2`                   VARCHAR(100),
    `Payment Typology 3`                   VARCHAR(100),
    `Birth Weight`                         VARCHAR(20),
    `Emergency Department Indicator`       VARCHAR(10),
    `Total Charges`                        VARCHAR(50),
    `Total Costs`                          VARCHAR(50)
);

-- ----------------------------------------------------------
-- 3.  Enable LOCAL INFILE if not already
-- ----------------------------------------------------------
SET GLOBAL local_infile = 1;

-- ----------------------------------------------------------
-- 4.  Load CSV safely with NULL handling
-- ----------------------------------------------------------
-- ⚠️  Edit the file path below for your environment.
LOAD DATA LOCAL INFILE
'C:/Users/delga/Documents/Projects/electronic_health_records_kpi_newyork/data/Hospital_Inpatient_Discharges__SPARCS_De-Identified___2023.csv'
INTO TABLE discharges_raw
CHARACTER SET UTF8MB4
FIELDS TERMINATED BY ',' ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 LINES
    (@hsa,@county,@ocn,@pfid,@facility,@age,@zip3,@gender,@race,@ethnicity,
    @los,@admtype,@disp,@year,@dx_code,@dx_desc,@px_code,@px_desc,
    @drg_code,@drg_desc,@mdc_code,@mdc_desc,@sev_code,@sev_desc,
    @rom,@medsurg,@payer1,@payer2,@payer3,@bw,@ed,@charges,@costs)
SET
`Hospital Service Area`                = NULLIF(@hsa,''),
`Hospital County`                      = NULLIF(@county,''),
`Operating Certificate Number`         = NULLIF(@ocn,''),
`Permanent Facility Id`                = NULLIF(@pfid,''),
`Facility Name`                        = NULLIF(@facility,''),
`Age Group`                            = NULLIF(@age,''),
`Zip Code - 3 digits`                  = CASE
                                            WHEN @zip3 REGEXP '^[0-9]{3}$' THEN @zip3
                                            ELSE NULL
                                        END,
`Gender`                               = NULLIF(@gender,''),
`Race`                                 = NULLIF(@race,''),
`Ethnicity`                            = NULLIF(@ethnicity,''),
`Length of Stay`                       = NULLIF(@los,''),
`Type of Admission`                    = NULLIF(@admtype,''),
`Patient Disposition`                  = NULLIF(@disp,''),
`Discharge Year`                       = NULLIF(@year,''),
`CCSR Diagnosis Code`                  = NULLIF(@dx_code,''),
`CCSR Diagnosis Description`           = NULLIF(@dx_desc,''),
`CCSR Procedure Code`                  = NULLIF(@px_code,''),
`CCSR Procedure Description`           = NULLIF(@px_desc,''),
`APR DRG Code`                         = NULLIF(@drg_code,''),
`APR DRG Description`                  = NULLIF(@drg_desc,''),
`APR MDC Code`                         = NULLIF(@mdc_code,''),
`APR MDC Description`                  = NULLIF(@mdc_desc,''),
`APR Severity of Illness Code`         = NULLIF(@sev_code,''),
`APR Severity of Illness Description`  = NULLIF(@sev_desc,''),
`APR Risk of Mortality`                = NULLIF(@rom,''),
`APR Medical Surgical Description`     = NULLIF(@medsurg,''),
`Payment Typology 1`                   = NULLIF(@payer1,''),
`Payment Typology 2`                   = NULLIF(@payer2,''),
`Payment Typology 3`                   = NULLIF(@payer3,''),
`Birth Weight`                         = NULLIF(@bw,''),
`Emergency Department Indicator`       = NULLIF(@ed,''),
`Total Charges`                        = NULLIF(@charges,''),
`Total Costs`                          = NULLIF(@costs,'');

-- ----------------------------------------------------------
-- 5.  Verify load
-- ----------------------------------------------------------
SELECT COUNT(*) AS rows_loaded FROM discharges_raw;
SHOW WARNINGS LIMIT 10;