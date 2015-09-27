xml.Organization(xmlns:"http://hl7.org/fhir") do
  xml.identifier do
    xml.use(value: "official")
    xml.label(value: "NPI")
    xml.system(value: "https://nppes.cms.hhs.gov/NPPES/")
    xml.value(value: organization.npi)
  end

  xml.name(value: organization.organization_name_legal_business_name)
  # Assuming the only orgs are providers (for now)
  xml.type do
    xml << render(partial: 'fhir/shared_elements/xml/codeable_concept.xml.builder',
      locals: {codings: [{code: "prov", display: "Healthcare Provider"}], text: nil})
  end


  telecoms = []
  telecoms = telecoms + [{ system: "phone", number: organization.mailing_address.telephone_number, period: nil },
    { system: "fax", number: organization.mailing_address.fax_number, period: nil }] if organization.mailing_address
  telecoms = telecoms + [{ system: "phone", number: organization.practice_location_address.telephone_number, period: nil },
    { system: "fax", number: organization.practice_location_address.fax_number, period: nil }] if organization.practice_location_address
  telecoms.each do |locals|
    xml.telecom do
      xml << render(partial: 'fhir/shared_elements/xml/contact_point.xml.builder', locals: locals)
    end unless locals[:number].blank?
  end

  [organization.practice_location_address, organization.mailing_address].each do |address|
    xml.address do
      xml << render(partial: 'fhir/shared_elements/xml/address.xml.builder', locals: {address: address})
    end if address
  end

  # This may be something to try in the near future
  # <partOf><!-- 0..1 Resource(Organization) The organization of which this organization forms a part --></partOf>
  # <contact>  <!-- 0..* Contact for the organization for a certain purpose -->
  #   <purpose><!-- 0..1 CodeableConcept The type of contact --></purpose>
  #   <name><!-- 0..1 HumanName A name associated with the contact --></name>
  #   <telecom><!-- 0..* Contact Contact details (telephone, email, etc)  for a contact --></telecom>
  #   <address><!-- 0..1 Address Visiting or postal addresses for the contact --></address>
  # </contact>

  # Possibly use the practice_location_address?
  # <location><!-- 0..* Resource(Location) Location(s) the organization uses to provide services --></location>

  # <active value="[boolean]"/><!-- 0..1 Whether the organization's record is still in active use -->
end
