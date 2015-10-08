xml.Practitioner(xmlns:"http://hl7.org/fhir") do
  xml.identifier do
    xml.use(value: "official")
    xml.system(value: "https://nppes.cms.hhs.gov/NPPES/")
    xml.value(value: provider.npi)
  end

  xml.name do
    xml << render(partial: "fhir/shared_elements/xml/human_name.xml.builder", locals: {
      code: "official",
      last_name: provider.last_name_legal_name,
      first_name: provider.first_name,
      middle_name: provider.middle_name,
      prefix: provider.name_prefix,
      suffix: provider.name_suffix
    })
  end
  telecoms = []
  telecoms = telecoms + [{ system: "phone", value: provider.mailing_address.telephone_number, rank: nil, period: nil },
    { system: "fax", value: provider.mailing_address.fax_number, rank: nil, period: nil }] if provider.mailing_address
  telecoms = telecoms + [{ system: "phone", value: provider.practice_location_address.telephone_number, rank: nil, period: nil },
    { system: "fax", value: provider.practice_location_address.fax_number, rank: nil, period: nil }] if provider.practice_location_address
  telecoms.each do |locals|
    xml.telecom do
      xml << render(partial: "fhir/shared_elements/xml/contact_point.xml.builder", locals: locals)
    end unless locals[:number].blank?
  end

  xml.address do
    xml << render(partial: "fhir/shared_elements/xml/address.xml.builder", locals: {address: provider.practice_location_address})
  end if provider.practice_location_address

  xml.gender(value: "male") if provider.gender_code == "M"
  xml.gender(value: "female") if provider.gender_code == "F"

  xml.practitionerRole do
    provider.taxonomy_licenses.each do |license|
      xml.specialty do
        specialization = " (" + license.taxonomy_code.specialization.to_s + ")" unless license.taxonomy_code.specialization.to_s.blank?
        xml << render(partial: "fhir/shared_elements/xml/codeable_concept.xml.builder",
          locals: {codings: [{code:license.license_number, display: license.taxonomy_code.classification.to_s + specialization.to_s}], text: nil})
      end
    end
  end

end
