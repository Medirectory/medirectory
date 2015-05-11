DROP TABLE healthcare_provider_taxonomy_group2;
CREATE TABLE IF NOT EXISTS healthcare_provider_taxonomy_group2 (
  taxonomy_group varchar_fk bigint references provider(npi)
);

INSERT INTO healthcare_provider_taxonomy_group2 (
  taxonomy_group
)
SELECT *
FROM (
  SELECT 
    healthcare_provider_taxonomy_group_1
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_1 is not null AND healthcare_provider_taxonomy_group_1 != ''
  UNION
  SELECT 
    healthcare_provider_taxonomy_group_2
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_2 is not null AND healthcare_provider_taxonomy_group_2 != ''
  UNION
  SELECT 
    healthcare_provider_taxonomy_group_3
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_3 is not null AND healthcare_provider_taxonomy_group_3 != ''
  UNION
  SELECT 
    healthcare_provider_taxonomy_group_4
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_4 is not null AND healthcare_provider_taxonomy_group_4 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_group_5
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_5 is not null AND healthcare_provider_taxonomy_group_5 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_group_6
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_6 is not null AND healthcare_provider_taxonomy_group_6 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_group_7
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_7 is not null AND healthcare_provider_taxonomy_group_7 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_group_8
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_8 is not null AND healthcare_provider_taxonomy_group_8 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_group_9
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_9 is not null AND healthcare_provider_taxonomy_group_9 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_group_10
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_10 is not null AND healthcare_provider_taxonomy_group_10 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_group_11
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_11 is not null AND healthcare_provider_taxonomy_group_11 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_group_12
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_12 is not null AND healthcare_provider_taxonomy_group_12 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_group_13
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_13 is not null AND healthcare_provider_taxonomy_group_13 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_group_14
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_14 is not null AND healthcare_provider_taxonomy_group_14 != ''
    UNION
  SELECT 
    healthcare_provider_taxonomy_group_15
  FROM nppes
  WHERE healthcare_provider_taxonomy_group_15 is not null AND healthcare_provider_taxonomy_group_15 != ''

) AS taxonomy_group_table