xml.Practitioner(xmlns:"http://hl7.org/fhir") do
  xml.identifier do
    xml.use(value: "official")
    xml.label(value: "NPI")
    xml.system(value: "https://nppes.cms.hhs.gov/NPPES/")
    xml.value(value: provider.npi)
  end

  xml.name do
    xml.use(value: "official")
    xml.text(value: provider.name_prefix.to_s + (provider.name_prefix.to_s.blank? ?  "": " ") + provider.first_name.to_s+ " " + provider.middle_name.to_s + (provider.middle_name.to_s.blank? ?  "": " ") + provider.last_name_legal_name.to_s + (provider.name_suffix.to_s.blank? ?  "": " ") + provider.name_suffix.to_s)

    xml.family(value: provider.last_name_legal_name)
    xml.given(value: provider.first_name) if provider.first_name
    xml.given(value: provider.middle_name) if provider.middle_name
    xml.prefix(value: provider.name_prefix) if provider.name_prefix
    xml.prefix(value: provider.name_suffix) if provider.name_suffix
  end

  [{ system: "phone", number: provider.mailing_address.telephone_number, period: nil }, 
    { system: "fax", number: provider.mailing_address.fax_number, period: nil },
    { system: "phone", number: provider.practice_location_address.telephone_number, period: nil },
    { system: "fax", number: provider.practice_location_address.fax_number, period: nil }].each do |locals|
    xml.telecom do
      xml << render(partial: 'api/v1/fhir_practitioners/xml/contact.xml.builder', locals: locals)
    end
  end

  xml.address do
    xml << render(partial: 'api/v1/fhir_practitioners/xml/address.xml.builder', locals: {address: provider.practice_location_address})
  end

  xml.gender do
    xml << render(partial: 'api/v1/fhir_practitioners/xml/codeable_concept.xml.builder', 
      locals: { codings: [{code: provider.gender_code, display: provider.gender_code}], text: nil})
  end

  xml.organization do
    xml << render(partial: 'api/v1/fhir_practitioners/xml/resource.xml.builder', 
      locals: {reference: nil, display: (provider.organizations.first.other_organization_name ?  provider.organizations.first.other_organization_name : provider.organizations.first.organization_name_legal_business_name)})
  end if provider.organizations.first

  provider.taxonomy_licenses.each do |license|
    xml.specialty do
      xml << render(partial: 'api/v1/fhir_practitioners/xml/codeable_concept.xml.builder', 
        locals: {codings: [{code:license.license_number, display: license.taxonomy_code.classification.to_s + " (" + license.taxonomy_code.specialization.to_s + ")"}], text: nil})
    end
  end

  xml.period do
    if provider.npi_reactivation_date
      xml << render(partial: 'api/v1/fhir_practitioners/xml/period.xml.builder', 
        locals: {startDate: provider.npi_reactivation_date, endDate: nil})
    else
      xml << render(partial: 'api/v1/fhir_practitioners/xml/period.xml.builder', 
        locals: {startDate: provider.enumeration_date, endDate: provider.npi_deactivation_date})
    end
  end

end