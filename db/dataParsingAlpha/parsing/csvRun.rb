# Takes two arguments, first is the database name where the data should be loaded, and the second is the file path to the NPPES data

require 'time'
require 'pg'
require 'csv'

conn = PG.connect( dbname: ARGV[0] )
createProvider = "CREATE TABLE IF NOT EXISTS provider (
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
  provider_other_last_name_type_code bigint,
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
);"
insertProvider = "INSERT INTO provider VALUES ("

createAddress = "CREATE TABLE IF NOT EXISTS address (
  type VARCHAR,
  first_line VARCHAR,
  second_line VARCHAR,
  city_name VARCHAR,
  state_name VARCHAR,
  postal_code VARCHAR,
  country_code VARCHAR,
  telephone_number VARCHAR,
  fax_number VARCHAR,
  npi_fk bigint references provider(npi)
);"
insertAddress = "INSERT INTO address VALUES ("

createHealthcareProviderTaxonomyGroup = "CREATE TABLE IF NOT EXISTS healthcare_provider_taxonomy_group (
  taxonomy_group varchar,
  npi_fk bigint references provider(npi)
);"
insertHealthcareProviderTaxonomyGroup = "INSERT INTO healthcare_provider_taxonomy_group VALUES ("

createOtherProvider = "CREATE TABLE IF NOT EXISTS other_provider (
  other_provider_identifier varchar,
  other_provider_identifier_type_code varchar,
  other_provider_identifier_state varchar,
  other_provider_identifier_issuer varchar,
  npi_fk bigint references provider(npi)
);"
insertOtherProvider = "INSERT INTO other_provider VALUES ("

createTaxonomyTable = "CREATE TABLE IF NOT EXISTS taxonomy_license (
  healthcare_provider_taxonomy_code varchar,
  provider_license_number varchar,
  provider_license_number_state_code varchar,
  healthcare_provider_primary_taxonomy_switch varchar,
  npi_fk bigint references provider(npi)
);"
insertTaxonomyTable = "INSERT INTO taxonomy_license VALUES ("

def nullEmptyCheck(val)
  val.gsub!("'", "''")
  output = (!val || val.empty?) ? "DEFAULT" : "'"+val+"'"
  return output
end

def createInsert(csvIndicies, row, reportNull = false)
  output = ""
  nonNullCount = 0
  csvIndicies.each_with_index do |indicie, index|
    ending = index == csvIndicies.length-1 ? '' : ','
    deafultCheck = nullEmptyCheck(row[indicie])
    nonNullCount = nonNullCount + 1 if deafultCheck == "DEFAULT"
    output = output + deafultCheck + ending
  end
  if (nonNullCount == csvIndicies.length-1 && reportNull)
    output = nil
  end
  return output
end
puts Time.now
i = 0

conn.exec("DROP TABLE IF EXISTS address")
conn.exec("DROP TABLE IF EXISTS healthcare_provider_taxonomy_group")
conn.exec("DROP TABLE IF EXISTS other_provider")
conn.exec("DROP TABLE IF EXISTS taxonomy_license")
conn.exec("DROP TABLE IF EXISTS provider")

conn.exec(createProvider)
conn.exec(createAddress)
conn.exec(createHealthcareProviderTaxonomyGroup)
conn.exec(createOtherProvider)
conn.exec(createTaxonomyTable)
output = ""
CSV.foreach(ARGV[1], :headers => true) do |row| 
  i = i + 1
  output = output + insertProvider+
  (
    createInsert(["NPI","Entity Type Code",
      "Replacement NPI",
      "Employer Identification Number (EIN)",
      "Provider Organization Name (Legal Business Name)",
      "Provider Last Name (Legal Name)",
      "Provider First Name",
      "Provider Middle Name",
      "Provider Name Prefix Text",
      "Provider Name Suffix Text",
      "Provider Credential Text",
      "Provider Other Organization Name",
      "Provider Other Organization Name Type Code",
      "Provider Other Last Name",
      "Provider Other First Name",
      "Provider Other Middle Name",
      "Provider Other Name Prefix Text",
      "Provider Other Name Suffix Text",
      "Provider Other Credential Text",
      "Provider Other Last Name Type Code",
      "Provider Enumeration Date",
      "Last Update Date",
      "NPI Deactivation Reason Code",
      "NPI Deactivation Date",
      "NPI Reactivation Date",
      "Provider Gender Code",
      "Authorized Official Last Name",
      "Authorized Official First Name",
      "Authorized Official Middle Name",
      "Authorized Official Title or Position",
      "Authorized Official Telephone Number",
      "Is Sole Proprietor",
      "Is Organization Subpart",
      "Parent Organization LBN",
      "Parent Organization TIN",
      "Authorized Official Name Prefix Text",
      "Authorized Official Name Suffix Text",
      "Authorized Official Credential Text"
    ], row) + ');'
  )+
  insertAddress+ "'mailing'," + 
  (
    createInsert(["Provider First Line Business Mailing Address","Provider Second Line Business Mailing Address",
    "Provider Business Mailing Address City Name","Provider Business Mailing Address State Name",
    "Provider Business Mailing Address Postal Code","Provider Business Mailing Address Country Code (If outside U.S.)",
    "Provider Business Mailing Address Telephone Number","Provider Business Mailing Address Fax Number","NPI"], row) + ');'
  )+
  insertAddress+ "'practice_location'," +
  (
    createInsert(["Provider First Line Business Practice Location Address","Provider Second Line Business Practice Location Address",
    "Provider Business Practice Location Address City Name","Provider Business Practice Location Address State Name",
    "Provider Business Practice Location Address Postal Code","Provider Business Practice Location Address Country Code (If outside U.S.)",
    "Provider Business Practice Location Address Telephone Number","Provider Business Practice Location Address Fax Number","NPI"], row) + ');'
  )
  for j in 1..15
    toInsert = createInsert(["Healthcare Provider Taxonomy Group_#{j}","NPI"], row, true) 
    if toInsert == nil
      next
    end
    output = output + insertHealthcareProviderTaxonomyGroup + toInsert + ');'
  end
  for j in 1..50
    toInsert = createInsert(["Other Provider Identifier_#{j}", "Other Provider Identifier Type Code_#{j}", 
      "Other Provider Identifier State_#{j}", "Other Provider Identifier Issuer_#{j}","NPI"], row, true) 
    if toInsert == nil
      next
    end
    output = output + insertOtherProvider + toInsert + ');'
  end
  for j in 1..15
    toInsert = createInsert(["Healthcare Provider Taxonomy Code_#{j}", "Provider License Number_#{j}", 
      "Provider License Number State Code_#{j}", "Healthcare Provider Primary Taxonomy Switch_#{j}","NPI"], row, true) 
    if toInsert == nil
      next
    end
    output = output + insertOtherProvider + toInsert + ');'
  end
  if i == 40

    conn.exec(output)
    output = ""
    i = 0
  end

end
conn.exec(output)
puts Time.now
puts i
