json.coding codings do |coding|
  json.partial! "api/v1/fhir_practitioners/json/coding.json.jbuilder", 
  locals: { 
    uri: coding[:uri],
    version: coding[:version],
    code: coding[:code],
    display: coding[:display],
    primary: coding[:primary],
    valueSet: coding[:valueSet]
  }
end

json.text text if text