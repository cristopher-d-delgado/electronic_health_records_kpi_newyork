-- ----------------------------------------------------------
-- 1. Create clean analytical view with numeric conversions
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW discharges AS
SELECT
    `Hospital County`                      AS hospital_county,
    `Facility Name`                        AS facility_name,
    `Age Group`                            AS age_group,
    `Gender`                               AS gender,
    `Race`                                 AS race,
    `Ethnicity`                            AS ethnicity,
    `Discharge Year`                       AS discharge_year,
    `Type of Admission`                    AS type_of_admission,
    `APR Severity of Illness Description`  AS apr_severity_desc,
    `APR Risk of Mortality`                AS apr_risk_of_mortality,
    `Payment Typology 1`                   AS payment_typology_1,
    CAST(`Length of Stay` AS SIGNED)       AS length_of_stay,
    CAST(REPLACE(`Total Charges`, ',', '') AS DECIMAL(12,2)) AS total_charges,
    CAST(REPLACE(`Total Costs`, ',', '')   AS DECIMAL(12,2)) AS total_costs
FROM discharges_raw;
