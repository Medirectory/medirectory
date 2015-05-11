DROP TABLE provider;
CREATE TABLE IF NOT EXISTS provider (
  npi bigint PRIMARY KEY,
  entity_type_code int,
  replacement_npi bigint,
  ein varchar,
  provider_organization_name_legal_business_name varchar,
  provider_last_name_legal_name varchar,
  provider_first_name varchar,
  provider_middle_name varchar,
  provider_name_prefix varchar,
  provider_name_suffix varchar,
  provider_credential varchar,
  provider_other_organization_name varchar,
  provider_other_organization_name_type_code varchar,
  provider_other_last_name varchar,
  provider_other_first_name varchar,
  provider_other_middle_name varchar,
  provider_other_name_prefix varchar,
  provider_other_name_suffix varchar,
  provider_other_credential varchar,
  provider_other_last_name_type_code int,
  business_mailing_address_id_fk int references address(id),
  business_practice_location_address_id_fk int references address(id),
  provider_enumeration_date date,
  last_update_date date,
  npi_deactivation_reason_code varchar,
  npi_deactivation_date date,
  npi_reactivation_date date,
  provider_gender_code varchar,
  authorized_official_last_name varchar,
  authorized_official_first_name varchar,
  authorized_official_middle_name varchar,
  authorized_official_titleor_position varchar,
  authorized_official_telephone_number varchar,
  is_sole_proprietor varchar,
  is_organization_subpart varchar,
  parent_organization_lbn varchar,
  parent_organization_tin varchar,
  authorized_official_name_prefix varchar,
  authorized_official_name_suffix varchar,
  authorized_official_credential varchar
);

INSERT INTO provider (
  npi,
  entity_type_code,
  replacement_npi,
  ein,
  provider_organization_name_legal_business_name,
  provider_last_name_legal_name,
  provider_first_name,
  provider_middle_name,
  provider_name_prefix,
  provider_name_suffix,
  provider_credential,
  provider_other_organization_name,
  provider_other_organization_name_type_code,
  provider_other_last_name,
  provider_other_first_name,
  provider_other_middle_name,
  provider_other_name_prefix,
  provider_other_name_suffix,
  provider_other_credential,
  provider_other_last_name_type_code,
  business_mailing_address_id_fk,
  business_practice_location_address_id_fk,
  provider_enumeration_date,
  last_update_date,
  npi_deactivation_reason_code,
  npi_deactivation_date,
  npi_reactivation_date,
  provider_gender_code,
  authorized_official_last_name,
  authorized_official_first_name,
  authorized_official_middle_name,
  authorized_official_titleor_position,
  authorized_official_telephone_number,
  is_sole_proprietor,
  is_organization_subpart,
  parent_organization_lbn,
  parent_organization_tin,
  authorized_official_name_prefix,
  authorized_official_name_suffix,
  authorized_official_credential

)
SELECT *
FROM 
(
  SELECT npi,
    entity_type_code,
    replacement_npi,
    ein,
    provider_organization_name_legal_business_name,
    provider_last_name_legal_name,
    provider_first_name,
    provider_middle_name,
    provider_name_prefix,
    provider_name_suffix,
    provider_credential,
    provider_other_organization_name,
    provider_other_organization_name_type_code,
    provider_other_last_name,
    provider_other_first_name,
    provider_other_middle_name,
    provider_other_name_prefix,
    provider_other_name_suffix,
    provider_other_credential,
    provider_other_last_name_type_code,
    mailing.id,
    business.id,
    provider_enumeration_date,
    last_update_date,
    npi_deactivation_reason_code,
    npi_deactivation_date,
    npi_reactivation_date,
    provider_gender_code,
    authorized_official_last_name,
    authorized_official_first_name,
    authorized_official_middle_name,
    authorized_official_titleor_position,
    authorized_official_telephone_number,
    is_sole_proprietor,
    is_organization_subpart ,
    parent_organization_lbn,
    parent_organization_tin,
    authorized_official_name_prefix,
    authorized_official_name_suffix,
    authorized_official_credential
  FROM nppes 
    INNER JOIN address AS business ON (provider_first_line_business_practice_location_address = business.first_line 
      AND provider_second_line_business_practice_location_address = business.second_line
      AND provider_business_practice_location_address_city_name = business.city_name
      AND provider_business_practice_location_address_state_name = business.state_name
      AND provider_business_practice_location_address_postal_code = business.postal_code
      AND provider_business_practice_location_address_country_code_out_us = business.country_code
      AND provider_business_practice_location_address_telephone_number = business.telephone_number
      AND provider_business_practice_location_address_fax_number = business.fax_number) 
    INNER JOIN address AS mailing ON (provider_first_line_business_mailing_address = mailing.first_line
      AND provider_second_line_business_mailing_address = mailing.second_line
      AND provider_business_mailing_address_city_name = mailing.city_name
      AND provider_business_mailing_address_state_name = mailing.state_name
      AND provider_business_mailing_address_postal_code = mailing.postal_code
      AND provider_business_mailing_address_country_code_if_outside_us = mailing.country_code
      AND provider_business_mailing_address_telephone_number = mailing.telephone_number
      AND provider_business_mailing_address_fax_number = mailing.fax_number)
) AS providers