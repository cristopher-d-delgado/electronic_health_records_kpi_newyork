-- ----------------------------------------------------------
-- 1. Create clean analytical view with numeric conversions. Create our analysis Table
-- ----------------------------------------------------------
CREATE TABLE discharges AS
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
CREATE TABLE kpi_overview_new_york AS 
SELECT 
	discharge_year,
    COUNT(*) 							       AS total_discharges, -- Count of Amount of Discharges
	ROUND(AVG(length_of_stay), 0)			   AS avg_length_of_stay,
    ROUND(AVG(total_charges), 2)			   AS avg_total_charges,
    ROUND(AVG(total_costs), 2)				   AS avg_total_costs,
	ROUND(AVG(total_charges/NULLIF(length_of_stay,0)), 2) AS avg_charge_per_day
FROM discharges
GROUP BY discharge_year;

-- --------------------------------------------------------
-- 3. Hospital Performance & Utilization ------------------
-- --------------------------------------------------------
-- Discharges & LOS by hospital and year
CREATE TABLE kpi_hospital_performance_and_utilization AS 
SELECT 
	facility_name                           AS facility_name, 
    hospital_county                         AS hospital_county,
    discharge_year                          AS discharge_year,
    COUNT(*)							    AS total_discharges, -- total discharges per hospital per year
	ROUND(AVG(length_of_stay), 0) 			AS avg_length_of_stay -- avg length of stay per hospital per year
FROM discharges 
GROUP BY facility_name, hospital_county, discharge_year;

-- Utilization by clinical group (APR MDC)
-- Create CTE called counts which helps CTE ranked determine most prevelant diagnoses in each hospital
WITH counts AS (
	SELECT 
		facility_name, 
        hospital_county, 
        apr_mdc_description AS apr_mdc, 
        COUNT(*) AS total_discharges
	FROM discharges
    GROUP BY facility_name, hospital_county, apr_mdc_description
),
-- Create CTE ranked which helps identify the top diagnoses from each hospital which can be queried later on
ranked AS (
	SELECT 
		counts.*,
	-- Window function assigning sequential number to each hospital
	ROW_NUMBER() OVER (
		PARTITION BY facility_name -- Creates window per hospital
        ORDER BY total_discharges DESC, apr_mdc ASC -- Assign total discharges as descending to see top diagnoses 
	)
    AS rn 
    FROM counts
)
-- Create query to obtain top 3 diagnoses from each hospital in New York 
SELECT 
	facility_name, 
    hospital_county, 
    apr_mdc, 
    total_discharges,
    rn
FROM ranked
WHERE rn <= 3 -- Top 3 diagnoses 
ORDER BY facility_name, rn;

-- --------------------------------------------------------
-- 4. Cost & Charges Analysis -----------------------------
-- --------------------------------------------------------
-- Average total charges (by Diagnosis, Payer, and Hospital)

-- Top 10 Costliest Diagnoses

-- Average Cost per Day 

-- Correlation between Avg LOS and Total Charges

-- -------------------------------------------------------
-- 5. Patient Demographics & Health Trends
-- -------------------------------------------------------
-- Discharges by Age Group and Gender 

-- Top Diagnoses by Age Group and Gender 

-- Discharges by County

