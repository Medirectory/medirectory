DROP TABLE IF EXISTS taxonomy_license;
CREATE TABLE IF NOT EXISTS taxonomy_license (
  healthcare_provider_taxonomy_code varchar,
  provider_license_number varchar,
  provider_license_number_state_code varchar,
  healthcare_provider_primary_taxonomy_switch varchar,
  npi_fk bigint references provider(npi)
);

INSERT INTO taxonomy_license (
  healthcare_provider_taxonomy_code, 
  provider_license_number, 
  provider_license_number_state_code,
  healthcare_provider_primary_taxonomy_switch,
  npi_fk
)
SELECT * 
FROM
(
  SELECT 
    healthcare_provider_taxonomy_code_1,
    provider_license_number_1,
    provider_license_number_state_code_1,
    healthcare_provider_primary_taxonomy_switch_1,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_1 is not null AND healthcare_provider_taxonomy_code_1 != ''
  UNION
  SELECT 
    healthcare_provider_taxonomy_code_2,
    provider_license_number_2,
    provider_license_number_state_code_2,
    healthcare_provider_primary_taxonomy_switch_2,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_2 is not null AND healthcare_provider_taxonomy_code_2 != ''
  UNION
  SELECT 
    healthcare_provider_taxonomy_code_3,
    provider_license_number_3,
    provider_license_number_state_code_3,
    healthcare_provider_primary_taxonomy_switch_3,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_3 is not null AND healthcare_provider_taxonomy_code_3 != ''
  UNION
  SELECT 
    healthcare_provider_taxonomy_code_4,
    provider_license_number_4,
    provider_license_number_state_code_4,
    healthcare_provider_primary_taxonomy_switch_4,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_4 is not null AND healthcare_provider_taxonomy_code_4 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_code_5,
    provider_license_number_5,
    provider_license_number_state_code_5,
    healthcare_provider_primary_taxonomy_switch_5,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_5 is not null AND healthcare_provider_taxonomy_code_5 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_code_6,
    provider_license_number_6,
    provider_license_number_state_code_6,
    healthcare_provider_primary_taxonomy_switch_6,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_6 is not null AND healthcare_provider_taxonomy_code_6 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_code_7,
    provider_license_number_7,
    provider_license_number_state_code_7,
    healthcare_provider_primary_taxonomy_switch_7,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_7 is not null AND healthcare_provider_taxonomy_code_7 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_code_8,
    provider_license_number_8,
    provider_license_number_state_code_8,
    healthcare_provider_primary_taxonomy_switch_8,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_8 is not null AND healthcare_provider_taxonomy_code_8 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_code_9,
    provider_license_number_9,
    provider_license_number_state_code_9,
    healthcare_provider_primary_taxonomy_switch_9,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_9 is not null AND healthcare_provider_taxonomy_code_9 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_code_10,
    provider_license_number_10,
    provider_license_number_state_code_10,
    healthcare_provider_primary_taxonomy_switch_10,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_10 is not null AND healthcare_provider_taxonomy_code_10 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_code_11,
    provider_license_number_11,
    provider_license_number_state_code_11,
    healthcare_provider_primary_taxonomy_switch_11,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_11 is not null AND healthcare_provider_taxonomy_code_11 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_code_12,
    provider_license_number_12,
    provider_license_number_state_code_12,
    healthcare_provider_primary_taxonomy_switch_12,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_12 is not null AND healthcare_provider_taxonomy_code_12 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_code_13,
    provider_license_number_13,
    provider_license_number_state_code_13,
    healthcare_provider_primary_taxonomy_switch_13,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_13 is not null AND healthcare_provider_taxonomy_code_13 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_code_14,
    provider_license_number_14,
    provider_license_number_state_code_14,
    healthcare_provider_primary_taxonomy_switch_14,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_14 is not null AND healthcare_provider_taxonomy_code_14 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_code_15,
    provider_license_number_15,
    provider_license_number_state_code_15,
    healthcare_provider_primary_taxonomy_switch_15,
    npi
  FROM nppes
  WHERE healthcare_provider_taxonomy_code_15 is not null AND healthcare_provider_taxonomy_code_15 != ''

) AS test