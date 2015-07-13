json.resourceType "Conformance"
json.publisher "MITRE"
json.description "Test implementation of the FHIR markup for our database"
json.experimental "true"
json.date "2015-07-10T09:08:29.499-04:00"
json.fhirVersion "0.0.82"
json.acceptUnknown "false"
json.format ["xml", "json"]
json.rest [0] do |test|
  json.mode "server"
  json.documentation "Only implements practitioners"
  json.resource [0] do |test|
    json.type "Practitioner"
    json.operation [0] do |test|
      json.code "read"
      json.documentation "can only retrieve via ids"
    end
    json.readHistory "false"
    json.updateCreate "false"
  end
end