json.resourceType "List"
json.mode "working"
json.entry @providers do |provider|
  json.item do
    json.partial! 'fhir/practitioners/json/resource.json.jbuilder', locals: { 
      reference: Rails.application.routes.url_helpers.fhir_practitioner_path(provider.npi, format: :json), 
      display: provider.first_name.to_s + " " + provider.last_name_legal_name.to_s}
  end
end