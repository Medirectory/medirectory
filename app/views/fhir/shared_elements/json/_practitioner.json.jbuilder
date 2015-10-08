json.resourceType "Practitioner"
# Id (NPI)
json.identifier [nil] do
  json.use "official"
  json.system "https://nppes.cms.hhs.gov/NPPES/"
  json.value provider.npi.to_s
end
# Name
json.name do
  json.partial! 'fhir/shared_elements/json/human_name.json.jbuilder', locals: {
    code: 'official',
    last_name: provider.last_name_legal_name,
    first_name: provider.first_name,
    middle_name: provider.middle_name,
    prefix: provider.name_prefix,
    suffix: provider.name_suffix
  }
end

telecoms = []
telecoms = telecoms + [{ system: "phone", value: provider.mailing_address.telephone_number, rank: nil, period: nil },
  { system: "fax", value: provider.mailing_address.fax_number, rank: nil, period: nil }] if provider.mailing_address
telecoms = telecoms + [{ system: "phone", value: provider.practice_location_address.telephone_number, rank: nil, period: nil },
  { system: "fax", value: provider.practice_location_address.fax_number, rank: nil, period: nil }] if provider.practice_location_address
json.telecom telecoms do |locals|
  json.partial! 'fhir/shared_elements/json/contact_point.json.jbuilder', locals: locals unless locals[:number].blank?
end

json.address do
  json.partial! 'fhir/shared_elements/json/address.json.jbuilder', locals: { address: provider.practice_location_address}
end if provider.practice_location_address


json.gender "male" if provider.gender_code == "M"
json.gender "female" if provider.gender_code == "F"

json.practitionerRole [nil] do
  json.specialty provider.taxonomy_licenses do |license|
    specialization = " (" + license.taxonomy_code.specialization.to_s + ")" unless license.taxonomy_code.specialization.to_s.blank?
    json.partial! 'fhir/shared_elements/json/codeable_concept.json.jbuilder',
      locals: {codings: [{code:license.license_number, display: license.taxonomy_code.classification.to_s + specialization.to_s}], text: nil}
  end
end
