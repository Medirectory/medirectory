xml.List(xmlns:"http://hl7.org/fhir") do
  xml.mode(value: "working")
  @providers.each do |provider|
    xml.entry do
      xml.item do
        xml << render(:partial => 'api/v1/fhir/practitioners/xml/resource.xml.builder', locals: { 
          reference: Rails.application.routes.url_helpers.api_v1_fhir_practitioner_path(provider.npi) + ".xml", 
          display: provider.first_name.to_s + " " + provider.last_name_legal_name.to_s})
      end
    end
  end
end