DROP TABLE address;
CREATE TABLE IF NOT EXISTS address (
  id BIGSERIAL PRIMARY KEY,
  first_line VARCHAR,
  second_line VARCHAR,
  city_name VARCHAR,
  state_name VARCHAR,
  postal_code VARCHAR,
  country_code VARCHAR,
  telephone_number VARCHAR,
  fax_number VARCHAR,
  UNIQUE (first_line, second_line, city_name, state_name, postal_code, country_code, telephone_number, fax_number)
);

INSERT INTO address (first_line, second_line, city_name, state_name, postal_code, country_code, telephone_number, fax_number)
SELECT *
FROM 
(
  SELECT provider_first_line_business_mailing_address as first_line, provider_second_line_business_mailing_address as second_line,
    provider_business_mailing_address_city_name as city_name, provider_business_mailing_address_state_name as state_name, 
    provider_business_mailing_address_postal_code as postal_code, provider_business_mailing_address_country_code_if_outside_us as country_code, 
    provider_business_mailing_address_telephone_number as telephone_number, provider_business_mailing_address_fax_number as fax_number
  FROM nppes
  UNION
  SELECT provider_first_line_business_practice_location_address as first_line, provider_second_line_business_practice_location_address as second_line,
    provider_business_practice_location_address_city_name as city_name, provider_business_practice_location_address_state_name as state_name, 
    provider_business_practice_location_address_postal_code as postal_code, provider_business_practice_location_address_country_code_out_us as country_code, 
    provider_business_practice_location_address_telephone_number as telephone_number, provider_business_practice_location_address_fax_number as fax_number
  FROM nppes
) AS addresses