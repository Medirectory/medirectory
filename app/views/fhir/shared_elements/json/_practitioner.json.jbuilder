json.resourceType "Practitioner"
# Id (NPI)
json.identifier [nil] do
  json.use "official"
  json.label "NPI"
  json.system "https://nppes.cms.hhs.gov/NPPES/"
  json.value provider.npi.to_s
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

telecoms = []
telecoms = telecoms + [{ system: "phone", number: provider.mailing_address.telephone_number, period: nil },
  { system: "fax", number: provider.mailing_address.fax_number, period: nil }] if provider.mailing_address
telecoms = telecoms + [{ system: "phone", number: provider.practice_location_address.telephone_number, period: nil },
  { system: "fax", number: provider.practice_location_address.fax_number, period: nil }] if provider.practice_location_address
json.telecom telecoms do |locals|
  json.partial! 'fhir/shared_elements/json/contact.json.jbuilder', locals: locals unless locals[:number].blank?
end

json.address do
  json.partial! 'fhir/shared_elements/json/address.json.jbuilder', locals: { address: provider.practice_location_address}
end if provider.practice_location_address

json.gender do
  json.partial! 'fhir/shared_elements/json/codeable_concept.json.jbuilder',
    locals: { codings: [{code: provider.gender_code, display: provider.gender_code}], text: nil}
end

json.organization do
  json.partial! 'fhir/shared_elements/json/resource.json.jbuilder',
    locals: {reference: nil, display: (provider.organizations.first.other_organization_name ?  provider.organizations.first.other_organization_name : provider.organizations.first.organization_name_legal_business_name)}
end if provider.organizations.first

json.specialty provider.taxonomy_licenses do |license|
  specialization = " (" + license.taxonomy_code.specialization.to_s + ")" unless license.taxonomy_code.specialization.to_s.blank?
  json.partial! 'fhir/shared_elements/json/codeable_concept.json.jbuilder',
    locals: {codings: [{code:license.license_number, display: license.taxonomy_code.classification.to_s + specialization.to_s}], text: nil}
end

json.period do
  if provider.npi_reactivation_date
    json.partial! 'fhir/shared_elements/json/period.json.jbuilder',
      locals: {startDate: provider.npi_reactivation_date, endDate: nil}
  else
    json.partial! 'fhir/shared_elements/json/period.json.jbuilder',
      locals: {startDate: provider.enumeration_date, endDate: provider.npi_deactivation_date}
  end
end
