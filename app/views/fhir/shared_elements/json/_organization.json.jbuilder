json.resourceType "Organization"
json.identifier [nil] do
  json.use "official"
  json.system "https://nppes.cms.hhs.gov/NPPES/"
  json.value organization.npi.to_s
end

json.name organization.organization_name_legal_business_name
# Assuming the only orgs are providers (for now)
# json.type do
#   json.partial! 'fhir/shared_elements/json/codeable_concept.json.jbuilder',
#     locals: {codings: [{code: "prov", display: "Healthcare Provider"}], text: nil}
# end
telecoms = []
telecoms = telecoms + [{ system: "phone", value: organization.mailing_address.telephone_number, rank: nil, period: nil },
  { system: "fax", value: organization.mailing_address.fax_number, rank: nil, period: nil }] if organization.mailing_address
telecoms = telecoms + [{ system: "phone", value: organization.practice_location_address.telephone_number, rank: nil, period: nil },
  { system: "fax", value: organization.practice_location_address.fax_number, rank: nil, period: nil }] if organization.practice_location_address
json.telecom telecoms do |locals|
    json.partial! 'fhir/shared_elements/json/contact_point.json.jbuilder', locals: locals unless locals[:number].blank?
end

json.address [organization.practice_location_address, organization.mailing_address] do |address|
    json.partial! 'fhir/shared_elements/json/address.json.jbuilder', locals: {address: address} if address
end

json.contact do
  json.name do
    json.partial! "fhir/shared_elements/json/human_name.json.jbuilder", locals: {
      code: "official",
      last_name: organization.authorized_official_last_name,
      first_name: organization.authorized_official_first_name,
      middle_name: organization.authorized_official_middle_name,
      prefix: organization.authorized_official_name_prefix,
      suffix: organization.authorized_official_name_suffix
    }
  end
  json.telecom [nil] do
    json.partial! 'fhir/shared_elements/json/contact_point.json.jbuilder', locals: {
      system: "phone",
      value: organization.authorized_official_telephone_number,
      rank: nil,
      period: nil
    }
  end if organization.authorized_official_telephone_number
end if organization.authorized_official_last_name
