json.resourceType "Conformance"
json.publisher "MITRE"
json.description "Test implementation of the FHIR markup for our database"
json.experimental "true"
json.date "2015-07-10T09:08:29.499-04:00"
json.fhirVersion "0.0.82"
json.acceptUnknown "false"
json.format ["json", "json"]
json.rest [nil] do
  json.mode "server"
  json.documentation "Only implements practitioners"
  json.resource [nil] do
    json.type "Practitioner"
    json.operation [nil] do
      json.code "read"
      json.documentation "can only retrieve via ids"
    end
    json.operation [nil] do
      json.code "search-type"
      json.documentation "No search criteria leads to all practitioners beings returned"
    end
    json.searchParam [nil] do
      json.name "_id"
      json.type "string"
      json.documentation "All practitioners with id"
    end
    json.searchParam [nil] do
      json.name "name"
      json.type "string"
      json.documentation "All practitioners with first or last name matching value"
    end
    json.searchParam [nil] do
      json.name "given_name"
      json.type "string"
      json.documentation "All practitioners with first name matching value"
    end
    json.searchParam [nil] do
      json.name "family_name"
      json.type "string"
      json.documentation "All practitioners with last name matching value"
    end
  end
end
