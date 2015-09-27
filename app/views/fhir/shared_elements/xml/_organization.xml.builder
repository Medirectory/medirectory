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
  telecoms = telecoms + [{ system: "phone", value: organization.mailing_address.telephone_number, rank: nil, period: nil },
    { system: "fax", value: organization.mailing_address.fax_number, rank: nil, period: nil }] if organization.mailing_address
  telecoms = telecoms + [{ system: "phone", value: organization.practice_location_address.telephone_number, rank: nil, period: nil },
    { system: "fax", value: organization.practice_location_address.fax_number, rank: nil, period: nil }] if organization.practice_location_address
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

  xml.contact do
    xml.name do
      xml << render(partial: "fhir/shared_elements/xml/human_name.xml.builder", locals: {
        code: "official",
        last_name: organization.authorized_official_last_name,
        first_name: organization.authorized_official_first_name,
        middle_name: organization.authorized_official_middle_name,
        prefix: organization.authorized_official_name_prefix,
        suffix: organization.authorized_official_name_suffix
      })
    end
    xml.telecom do
      xml << render(partial: 'fhir/shared_elements/xml/contact_point.xml.builder', locals: {
        system: "phone",
        value: organization.authorized_official_telephone_number,
        rank: nil,
        period: nil
      })
    end if organization.authorized_official_telephone_number
  end if organization.authorized_official_last_name
end
