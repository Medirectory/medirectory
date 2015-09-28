json.resourceType "Bundle"
json.type "searchset"
json.total total
json.link [{rel: "self", url: link_to[:self]},
  {relation: "first", url: link_to[:first]},
  {relation: "previous", url: link_to[:previous]},
  {relation: "next", url: link_to[:next]},
  {relation: "last", url: link_to[:last]}] do |link|
    json.relation link[:relation]
    json.url link[:url]
end
json.entry entities do |entity|
  json.fullUrl link_to[:base] + Rails.application.routes.url_helpers.fhir_practitioner_path(entity.npi, _format: :xml) if type == "practitioner"
  json.fullUrl link_to[:base] + Rails.application.routes.url_helpers.fhir_organization_path(entity.npi, _format: :xml) if type == "organization"
  json.resource do
    json.partial! 'fhir/shared_elements/json/practitioner', provider: entity if type == "practitioner"
    json.partial! 'fhir/shared_elements/json/organization', organization: entity if type == "organization"
  end
  json.search do
    json.mode "match"
  end
end
