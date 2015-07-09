codings.each do |coding|
  xml.coding do
    xml << render(partial: "api/v1/fhir/practitioners/xml/coding.xml.builder", 
    locals: { 
      uri: coding[:uri],
      version: coding[:version],
      code: coding[:code],
      display: coding[:display],
      primary: coding[:primary],
      valueSet: coding[:valueSet]
    })
  end
end
xml.text(value: text) if text