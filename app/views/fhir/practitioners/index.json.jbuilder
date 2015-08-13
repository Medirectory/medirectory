json.resourceType "Bundle"
json.title "Search Result for param values: " + @params.to_s
json.link [{rel: "self", href: @link_to[:self]},
  {rel: "first", href: @link_to[:first]},
  {rel: "previous", href: @link_to[:previous]},
  {rel: "next", href: @link_to[:next]},
  {rel: "last", href: @link_to[:last]},
  {rel: "base", href: @link_to[:fhir_base]}] do |link|
    json.rel link[:rel]
    json.href link[:href]
end
json.totalResults @total
json.id @link_to[:self]
json.author [""] do
  json.name "Medirectory"
end
json.entry @providers do |provider|
    json.title provider.first_name.to_s + " " + provider.middle_name.to_s + " " + provider.last_name_legal_name.to_s
    json.id @link_to[:base] Rails.application.routes.url_helpers.fhir_practitioner_path(provider.npi, format: :json)
    json.updated provider.last_update_date.to_s + "T00:00:00"
    json.published (provider.npi_reactivation_date || provider.enumeration_date).to_s + "T00:00:00"
    json.author [""] do
      json.name "National Plan & Provider Enumeration System"
      json.uri "https://nppes.cms.hhs.gov"
    end
    json.content do
      json.partial! 'fhir/practitioners/json/practitioner', provider: provider
      # json.partial! 'fhir/practitioners/json/resource.json.jbuilder', locals: {
      #   reference: Rails.application.routes.url_helpers.fhir_practitioner_path(provider.npi, format: :json),
      #   display: provider.first_name.to_s + " " + provider.last_name_legal_name.to_s}
    end
end
