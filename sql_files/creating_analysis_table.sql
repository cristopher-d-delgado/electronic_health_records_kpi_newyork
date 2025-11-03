-- ----------------------------------------------------------
-- 1. Create clean analytical view with numeric conversions. Create our analysis Table
-- ----------------------------------------------------------
CREATE OR REPLACE VIEW discharges AS
SELECT
    `Hospital Service Area`				   AS hospital_service_area,
    `Hospital County`                      AS hospital_county,
    `Facility Name`                        AS facility_name,
    `Age Group`                            AS age_group,
    `Gender`                               AS gender,
    `Race`                                 AS race,
    `Ethnicity`                            AS ethnicity,
    `Type of Admission`				       AS type_of_admission,
    `Discharge Year`                       AS discharge_year,
    `APR MDC Description` 				   AS apr_mdc_description,
    `APR Severity of Illness Description`  AS apr_severity_desc,
    `APR Risk of Mortality`                AS apr_risk_of_mortality,
    `Payment Typology 1`                   AS payment_typology_1,
    CAST(`Length of Stay` AS SIGNED)       AS length_of_stay,
    CAST(REPLACE(`Total Charges`, ',', '') AS DECIMAL(12,2)) AS total_charges, -- Allows up to 12 numbers before and after decimal and allows only to upt two decimal places for cents
    CAST(REPLACE(`Total Costs`, ',', '')   AS DECIMAL(12,2)) AS total_costs
FROM discharges_raw;

-- ----------------------------------------------------------
-- 2. Create Base Key Performance Indicators ----------------
-- ----------------------------------------------------------
-- Help answer overall New York performance of hospitals
CREATE OR REPLACE VIEW kpi_overview_year AS 
SELECT 
	discharge_year,
    COUNT(*) 							       AS total_discharges, -- Count of Amount of Discharges
	ROUND(AVG(length_of_stay), 2)			   AS avg_length_of_stay,
    ROUND(AVG(total_charges), 2)			   AS avg_total_charges,
    ROUND(AVG(total_costs), 2)				   AS avg_total_costs,
	ROUND(AVG(total_charges/NULLIF(length_of_stay,0)), 2) AS avg_charge_per_day
FROM discharges
GROUP BY discharge_year;

-- --------------------------------------------------------
-- 3. Hospital Performance & Utilization ------------------
-- --------------------------------------------------------