json.resourceType "Practitioner"
# Id (NPI)
json.identifier [provider.npi] do |npi|
  json.use "official"
  json.label "NPI"
  json.system "https://nppes.cms.hhs.gov/NPPES/"
  json.value provider.npi
end
# Name
json.name do
  json.use "official"
  json.text provider.name_prefix.to_s + (provider.name_prefix.to_s.blank? ?  "": " ") + provider.first_name.to_s+ " " + provider.middle_name.to_s + (provider.middle_name.to_s.blank? ?  "": " ") + provider.last_name_legal_name.to_s + (provider.name_suffix.to_s.blank? ?  "": " ") + provider.name_suffix.to_s

  json.family [provider.last_name_legal_name]
  given_names = []
  given_names << provider.first_name if provider.first_name
  given_names << provider.middle_name if provider.middle_name
  json.given given_names
  json.prefix [provider.name_prefix] if provider.name_prefix
  json.prefix [provider.name_suffix] if provider.name_suffix
end

json.telecom [{ system: "phone", number: provider.mailing_address.telephone_number }, 
  { system: "fax", number: provider.mailing_address.fax_number },
  { system: "phone", number: provider.practice_location_address.telephone_number },
  { system: "fax", number: provider.practice_location_address.fax_number }] do |locals|
  json.partial! 'api/v1/fhir_practitioners/json/telecom.json.jbuilder', locals: locals
end

json.address [provider.mailing_address, provider.practice_location_address] do |address|
  json.partial! 'api/v1/fhir_practitioners/json/address.json.jbuilder', locals: { address: address}
end

json.gender do
  json.partial! 'api/v1/fhir_practitioners/json/codeable_concept.json.jbuilder', 
    locals: { codings: [{code: provider.gender_code, display: provider.gender_code}], text: nil}
end

json.organization do
  json.partial! 'api/v1/fhir_practitioners/json/resource.json.jbuilder', 
    locals: {reference: nil, display: (provider.organizations.first.other_organization_name ?  provider.organizations.first.other_organization_name : provider.organizations.first.organization_name_legal_business_name)}  
end if provider.organizations.first

json.specialty provider.taxonomy_licenses do |license|
  json.partial! 'api/v1/fhir_practitioners/json/codeable_concept.json.jbuilder', 
    locals: {codings: [{code:license.license_number, display: license.taxonomy_code.classification.to_s + " (" + license.taxonomy_code.specialization.to_s + ")"}], text: nil}
end
json.period do
  if provider.npi_reactivation_date
    json.partial! 'api/v1/fhir_practitioners/json/period.json.jbuilder', 
      locals: {startDate: provider.npi_reactivation_date, endDate: nil}
  else
    json.partial! 'api/v1/fhir_practitioners/json/period.json.jbuilder', 
      locals: {startDate: provider.enumeration_date, endDate: provider.npi_deactivation_date}
  end
end