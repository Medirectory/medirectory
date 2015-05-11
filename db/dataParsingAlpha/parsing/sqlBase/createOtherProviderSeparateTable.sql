DROP TABLE other_provider2;
CREATE TABLE IF NOT EXISTS other_provider2 (
  id BIGSERIAL PRIMARY KEY,
  other_provider_identifier varchar,
  other_provider_identifier_type_code varchar,
  other_provider_identifier_state varchar,
  other_provider_identifier_issuer varchar
);

INSERT INTO other_provider2 (
  other_provider_identifier, 
  other_provider_identifier_type_code,
  other_provider_identifier_state,
  other_provider_identifier_issuer
)
SELECT *
FROM (
  SELECT 
    other_provider_identifier_1,
    other_provider_identifier_type_code_1,
    other_provider_identifier_state_1,
    other_provider_identifier_issuer_1
  FROM nppes
  WHERE other_provider_identifier_1 is not null AND other_provider_identifier_1 != ''
  UNION
  SELECT 
    other_provider_identifier_2,
    other_provider_identifier_type_code_2,
    other_provider_identifier_state_2,
    other_provider_identifier_issuer_2
  FROM nppes
  WHERE other_provider_identifier_2 is not null AND other_provider_identifier_2 != ''
  UNION
  SELECT 
    other_provider_identifier_3,
    other_provider_identifier_type_code_3,
    other_provider_identifier_state_3,
    other_provider_identifier_issuer_3
  FROM nppes
  WHERE other_provider_identifier_3 is not null AND other_provider_identifier_3 != ''
  UNION
  SELECT 
    other_provider_identifier_4,
    other_provider_identifier_type_code_4,
    other_provider_identifier_state_4,
    other_provider_identifier_issuer_4
  FROM nppes
  WHERE other_provider_identifier_4 is not null AND other_provider_identifier_4 != ''
   UNION
   SELECT 
   other_provider_identifier_5,
   other_provider_identifier_type_code_5,
   other_provider_identifier_state_5,
   other_provider_identifier_issuer_5
   FROM nppes
   WHERE other_provider_identifier_5 is not null AND other_provider_identifier_5 != ''
  UNION
   SELECT 
   other_provider_identifier_6,
   other_provider_identifier_type_code_6,
   other_provider_identifier_state_6,
   other_provider_identifier_issuer_6
   FROM nppes
   WHERE other_provider_identifier_6 is not null AND other_provider_identifier_6 != ''
  UNION
   SELECT 
   other_provider_identifier_7,
   other_provider_identifier_type_code_7,
   other_provider_identifier_state_7,
   other_provider_identifier_issuer_7
   FROM nppes
   WHERE other_provider_identifier_7 is not null AND other_provider_identifier_7 != ''
  UNION
   SELECT 
   other_provider_identifier_8,
   other_provider_identifier_type_code_8,
   other_provider_identifier_state_8,
   other_provider_identifier_issuer_8
   FROM nppes
   WHERE other_provider_identifier_8 is not null AND other_provider_identifier_8 != ''
  UNION
   SELECT 
   other_provider_identifier_9,
   other_provider_identifier_type_code_9,
   other_provider_identifier_state_9,
   other_provider_identifier_issuer_9
   FROM nppes
   WHERE other_provider_identifier_9 is not null AND other_provider_identifier_9 != ''
  UNION
   SELECT 
   other_provider_identifier_10,
   other_provider_identifier_type_code_10,
   other_provider_identifier_state_10,
   other_provider_identifier_issuer_10
   FROM nppes
   WHERE other_provider_identifier_10 is not null AND other_provider_identifier_10 != ''
  UNION
   SELECT 
   other_provider_identifier_11,
   other_provider_identifier_type_code_11,
   other_provider_identifier_state_11,
   other_provider_identifier_issuer_11
   FROM nppes
   WHERE other_provider_identifier_11 is not null AND other_provider_identifier_11 != ''
  UNION
   SELECT 
   other_provider_identifier_12,
   other_provider_identifier_type_code_12,
   other_provider_identifier_state_12,
   other_provider_identifier_issuer_12
   FROM nppes
   WHERE other_provider_identifier_12 is not null AND other_provider_identifier_12 != ''
  UNION
   SELECT 
   other_provider_identifier_13,
   other_provider_identifier_type_code_13,
   other_provider_identifier_state_13,
   other_provider_identifier_issuer_13
   FROM nppes
   WHERE other_provider_identifier_13 is not null AND other_provider_identifier_13 != ''
  UNION
   SELECT 
   other_provider_identifier_14,
   other_provider_identifier_type_code_14,
   other_provider_identifier_state_14,
   other_provider_identifier_issuer_14
   FROM nppes
   WHERE other_provider_identifier_14 is not null AND other_provider_identifier_14 != ''
  UNION
   SELECT 
   other_provider_identifier_15,
   other_provider_identifier_type_code_15,
   other_provider_identifier_state_15,
   other_provider_identifier_issuer_15
   FROM nppes
   WHERE other_provider_identifier_15 is not null AND other_provider_identifier_15 != ''
  UNION
   SELECT 
   other_provider_identifier_16,
   other_provider_identifier_type_code_16,
   other_provider_identifier_state_16,
   other_provider_identifier_issuer_16
   FROM nppes
   WHERE other_provider_identifier_16 is not null AND other_provider_identifier_16 != ''
  UNION
   SELECT 
   other_provider_identifier_17,
   other_provider_identifier_type_code_17,
   other_provider_identifier_state_17,
   other_provider_identifier_issuer_17
   FROM nppes
   WHERE other_provider_identifier_17 is not null AND other_provider_identifier_17 != ''
  UNION
   SELECT 
   other_provider_identifier_18,
   other_provider_identifier_type_code_18,
   other_provider_identifier_state_18,
   other_provider_identifier_issuer_18
   FROM nppes
   WHERE other_provider_identifier_18 is not null AND other_provider_identifier_18 != ''
  UNION
   SELECT 
   other_provider_identifier_19,
   other_provider_identifier_type_code_19,
   other_provider_identifier_state_19,
   other_provider_identifier_issuer_19
   FROM nppes
   WHERE other_provider_identifier_19 is not null AND other_provider_identifier_19 != ''
  UNION
   SELECT 
   other_provider_identifier_20,
   other_provider_identifier_type_code_20,
   other_provider_identifier_state_20,
   other_provider_identifier_issuer_20
   FROM nppes
   WHERE other_provider_identifier_20 is not null AND other_provider_identifier_20 != ''
  UNION
   SELECT 
   other_provider_identifier_21,
   other_provider_identifier_type_code_21,
   other_provider_identifier_state_21,
   other_provider_identifier_issuer_21
   FROM nppes
   WHERE other_provider_identifier_21 is not null AND other_provider_identifier_21 != ''
  UNION
   SELECT 
   other_provider_identifier_22,
   other_provider_identifier_type_code_22,
   other_provider_identifier_state_22,
   other_provider_identifier_issuer_22
   FROM nppes
   WHERE other_provider_identifier_22 is not null AND other_provider_identifier_22 != ''
  UNION
   SELECT 
   other_provider_identifier_23,
   other_provider_identifier_type_code_23,
   other_provider_identifier_state_23,
   other_provider_identifier_issuer_23
   FROM nppes
   WHERE other_provider_identifier_23 is not null AND other_provider_identifier_23 != ''
  UNION
   SELECT 
   other_provider_identifier_24,
   other_provider_identifier_type_code_24,
   other_provider_identifier_state_24,
   other_provider_identifier_issuer_24
   FROM nppes
   WHERE other_provider_identifier_24 is not null AND other_provider_identifier_24 != ''
  UNION
   SELECT 
   other_provider_identifier_25,
   other_provider_identifier_type_code_25,
   other_provider_identifier_state_25,
   other_provider_identifier_issuer_25
   FROM nppes
   WHERE other_provider_identifier_25 is not null AND other_provider_identifier_25 != ''
  UNION
   SELECT 
   other_provider_identifier_26,
   other_provider_identifier_type_code_26,
   other_provider_identifier_state_26,
   other_provider_identifier_issuer_26
   FROM nppes
   WHERE other_provider_identifier_26 is not null AND other_provider_identifier_26 != ''
  UNION
   SELECT 
   other_provider_identifier_27,
   other_provider_identifier_type_code_27,
   other_provider_identifier_state_27,
   other_provider_identifier_issuer_27
   FROM nppes
   WHERE other_provider_identifier_27 is not null AND other_provider_identifier_27 != ''
  UNION
   SELECT 
   other_provider_identifier_28,
   other_provider_identifier_type_code_28,
   other_provider_identifier_state_28,
   other_provider_identifier_issuer_28
   FROM nppes
   WHERE other_provider_identifier_28 is not null AND other_provider_identifier_28 != ''
  UNION
   SELECT 
   other_provider_identifier_29,
   other_provider_identifier_type_code_29,
   other_provider_identifier_state_29,
   other_provider_identifier_issuer_29
   FROM nppes
   WHERE other_provider_identifier_29 is not null AND other_provider_identifier_29 != ''
  UNION
   SELECT 
   other_provider_identifier_30,
   other_provider_identifier_type_code_30,
   other_provider_identifier_state_30,
   other_provider_identifier_issuer_30
   FROM nppes
   WHERE other_provider_identifier_30 is not null AND other_provider_identifier_30 != ''
  UNION
   SELECT 
   other_provider_identifier_31,
   other_provider_identifier_type_code_31,
   other_provider_identifier_state_31,
   other_provider_identifier_issuer_31
   FROM nppes
   WHERE other_provider_identifier_31 is not null AND other_provider_identifier_31 != ''
  UNION
   SELECT 
   other_provider_identifier_32,
   other_provider_identifier_type_code_32,
   other_provider_identifier_state_32,
   other_provider_identifier_issuer_32
   FROM nppes
   WHERE other_provider_identifier_32 is not null AND other_provider_identifier_32 != ''
  UNION
   SELECT 
   other_provider_identifier_33,
   other_provider_identifier_type_code_33,
   other_provider_identifier_state_33,
   other_provider_identifier_issuer_33
   FROM nppes
   WHERE other_provider_identifier_33 is not null AND other_provider_identifier_33 != ''
  UNION
   SELECT 
   other_provider_identifier_34,
   other_provider_identifier_type_code_34,
   other_provider_identifier_state_34,
   other_provider_identifier_issuer_34
   FROM nppes
   WHERE other_provider_identifier_34 is not null AND other_provider_identifier_34 != ''
  UNION
   SELECT 
   other_provider_identifier_35,
   other_provider_identifier_type_code_35,
   other_provider_identifier_state_35,
   other_provider_identifier_issuer_35
   FROM nppes
   WHERE other_provider_identifier_35 is not null AND other_provider_identifier_35 != ''
  UNION
   SELECT 
   other_provider_identifier_36,
   other_provider_identifier_type_code_36,
   other_provider_identifier_state_36,
   other_provider_identifier_issuer_36
   FROM nppes
   WHERE other_provider_identifier_36 is not null AND other_provider_identifier_36 != ''
  UNION
   SELECT 
   other_provider_identifier_37,
   other_provider_identifier_type_code_37,
   other_provider_identifier_state_37,
   other_provider_identifier_issuer_37
   FROM nppes
   WHERE other_provider_identifier_37 is not null AND other_provider_identifier_37 != ''
  UNION
   SELECT 
   other_provider_identifier_38,
   other_provider_identifier_type_code_38,
   other_provider_identifier_state_38,
   other_provider_identifier_issuer_38
   FROM nppes
   WHERE other_provider_identifier_38 is not null AND other_provider_identifier_38 != ''
  UNION
   SELECT 
   other_provider_identifier_39,
   other_provider_identifier_type_code_39,
   other_provider_identifier_state_39,
   other_provider_identifier_issuer_39
   FROM nppes
   WHERE other_provider_identifier_39 is not null AND other_provider_identifier_39 != ''
  UNION
   SELECT 
   other_provider_identifier_40,
   other_provider_identifier_type_code_40,
   other_provider_identifier_state_40,
   other_provider_identifier_issuer_40
   FROM nppes
   WHERE other_provider_identifier_40 is not null AND other_provider_identifier_40 != ''
  UNION
   SELECT 
   other_provider_identifier_41,
   other_provider_identifier_type_code_41,
   other_provider_identifier_state_41,
   other_provider_identifier_issuer_41
   FROM nppes
   WHERE other_provider_identifier_41 is not null AND other_provider_identifier_41 != ''
  UNION
   SELECT 
   other_provider_identifier_42,
   other_provider_identifier_type_code_42,
   other_provider_identifier_state_42,
   other_provider_identifier_issuer_42
   FROM nppes
   WHERE other_provider_identifier_42 is not null AND other_provider_identifier_42 != ''
  UNION
   SELECT 
   other_provider_identifier_43,
   other_provider_identifier_type_code_43,
   other_provider_identifier_state_43,
   other_provider_identifier_issuer_43
   FROM nppes
   WHERE other_provider_identifier_43 is not null AND other_provider_identifier_43 != ''
  UNION
   SELECT 
   other_provider_identifier_44,
   other_provider_identifier_type_code_44,
   other_provider_identifier_state_44,
   other_provider_identifier_issuer_44
   FROM nppes
   WHERE other_provider_identifier_44 is not null AND other_provider_identifier_44 != ''
  UNION
   SELECT 
   other_provider_identifier_45,
   other_provider_identifier_type_code_45,
   other_provider_identifier_state_45,
   other_provider_identifier_issuer_45
   FROM nppes
   WHERE other_provider_identifier_45 is not null AND other_provider_identifier_45 != ''
  UNION
   SELECT 
   other_provider_identifier_46,
   other_provider_identifier_type_code_46,
   other_provider_identifier_state_46,
   other_provider_identifier_issuer_46
   FROM nppes
   WHERE other_provider_identifier_46 is not null AND other_provider_identifier_46 != ''
  UNION
   SELECT 
   other_provider_identifier_47,
   other_provider_identifier_type_code_47,
   other_provider_identifier_state_47,
   other_provider_identifier_issuer_47
   FROM nppes
   WHERE other_provider_identifier_47 is not null AND other_provider_identifier_47 != ''
  UNION
   SELECT 
   other_provider_identifier_48,
   other_provider_identifier_type_code_48,
   other_provider_identifier_state_48,
   other_provider_identifier_issuer_48
   FROM nppes
   WHERE other_provider_identifier_48 is not null AND other_provider_identifier_48 != ''
  UNION
   SELECT 
   other_provider_identifier_49,
   other_provider_identifier_type_code_49,
   other_provider_identifier_state_49,
   other_provider_identifier_issuer_49
   FROM nppes
   WHERE other_provider_identifier_49 is not null AND other_provider_identifier_49 != ''
  UNION
   SELECT 
   other_provider_identifier_50,
   other_provider_identifier_type_code_50,
   other_provider_identifier_state_50,
   other_provider_identifier_issuer_50
   FROM nppes
   WHERE other_provider_identifier_50 is not null AND other_provider_identifier_50 != ''
) as other_providers

