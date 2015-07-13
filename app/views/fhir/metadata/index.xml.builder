xml.Conformance(xmlns:"http://hl7.org/fhir") do
  xml.publisher(value: "MITRE")
  xml.description(value: "Test implementation of the FHIR markup for our database")
  xml.experimental(value: "true")
  xml.date(value: "2015-07-10T09:08:29.499-04:00")
  xml.fhirVersion(value: "0.0.82")
  xml.acceptUnknown(value: "false")
  xml.format(value: "xml")
  xml.format(value: "json")
  xml.rest do
    xml.mode(value: "server")
    xml.documentation(value: "Only implements practitioners")
    xml.resource do
      xml.type(value: "Practitioner")
      xml.operation do
        xml.code(value: "read")
        xml.documentation(value: "can only retrieve via ids")
      end
      xml.readHistory(value: "false")
      xml.updateCreate(value: "false")
    end
  end
end
