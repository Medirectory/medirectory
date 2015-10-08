xml.Bundle(xmlns: "http://hl7.org/fhir") do
  xml.type(value: "searchset")
  xml.total(value: total)
  xml.link do
    xml.relation(value: "self")
    xml.url(value: link_to[:self])
  end unless link_to[:self].empty?
  xml.link do
    xml.relation(value: "first")
    xml.url(value: link_to[:first])
  end unless link_to[:first].empty?
  xml.link do
    xml.relation(value: "previous")
    xml.url(value: link_to[:previous])
  end unless link_to[:previous].nil?
  xml.link do
    xml.relation(value: "next")
    xml.url(value: link_to[:next])
  end unless link_to[:next].nil?
  xml.link do
    xml.relation(value: "last")
    xml.url(value: link_to[:last])
  end unless link_to[:last].nil?
  entities.each do |entity|
    xml.entry do
      xml.fullUrl(value: link_to[:base] + Rails.application.routes.url_helpers.fhir_practitioner_path(entity.npi, _format: :xml)) if type == "practitioner"
      xml.fullUrl(value: link_to[:base] + Rails.application.routes.url_helpers.fhir_organization_path(entity.npi, _format: :xml)) if type == "organization"
      xml.resource do
        xml << render(:partial => 'fhir/shared_elements/xml/practitioner.xml.builder', locals: { provider: entity }) if type == "practitioner"
        xml << render(:partial => 'fhir/shared_elements/xml/organization.xml.builder', locals: { organization: entity }) if type == "organization"
      end
      xml.search do
        xml.mode(value: "match")
      end
    end
  end
end
