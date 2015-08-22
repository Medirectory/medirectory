json.resourceType "Organization"
json.identifier [nil] do
  json.use(value: "official")
  json.label(value: "NPI")
  json.system(value: "https://nppes.cms.hhs.gov/NPPES/")
  json.value(value: organization.npi)
end

json.name organization.organization_name_legal_business_name
# Assuming the only orgs are providers (for now)
json.type do
  json.partial! 'fhir/shared_elements/json/codeable_concept.json.jbuilder',
    locals: {codings: [{code: "prov", display: "Healthcare Provider"}], text: nil}
end

json.telecom [{ system: "phone", number: organization.mailing_address.telephone_number, period: nil },
  { system: "fax", number: organization.mailing_address.fax_number, period: nil },
  { system: "phone", number: organization.practice_location_address.telephone_number, period: nil },
  { system: "fax", number: organization.practice_location_address.fax_number, period: nil }] do |locals|
    json.partial! 'fhir/shared_elements/json/contact.json.jbuilder', locals: locals unless locals[:number].blank?
end

json.address [organization.practice_location_address, organization.mailing_address] do |address|
    json.partial! 'fhir/shared_elements/json/address.json.jbuilder', locals: {address: address}
end

# This may be something to try in the near future
# <partOf><!-- 0..1 Resource(Organization) The organization of which this organization forms a part --></partOf>
# <contact>  <!-- 0..* Contact for the organization for a certain purpose -->
#   <purpose><!-- 0..1 CodeableConcept The type of contact --></purpose>
#   <name><!-- 0..1 HumanName A name associated with the contact --></name>
#   <telecom><!-- 0..* Contact Contact details (telephone, email, etc)  for a contact --></telecom>
#   <address><!-- 0..1 Address Visiting or postal addresses for the contact --></address>
#   <gender><!-- 0..1 CodeableConcept Gender for administrative purposes --></gender>
# </contact>

# Possibly use the practice_location_address?
# <location><!-- 0..* Resource(Location) Location(s) the organization uses to provide services --></location>

# <active value="[boolean]"/><!-- 0..1 Whether the organization's record is still in active use -->
