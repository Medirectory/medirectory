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
      end
      xml.operation do
        xml.code(value: "search-type")
        xml.documentation(value: "No search criteria leads to all Practitioners beings returned")
      end
      xml.searchParam do
        xml.name(value: "_id")
        xml.type(value: "string")
        xml.documentation(value: "All Practitioners with id")
      end
      xml.searchParam do
        xml.name(value: "name")
        xml.type(value: "string")
        xml.documentation(value: "All Practitioners with first or last name matching value")
      end
      xml.searchParam do
        xml.name(value: "given_name")
        xml.type(value: "string")
        xml.documentation(value: "All Practitioners with first name matching value")
      end
      xml.searchParam do
        xml.name(value: "family_name")
        xml.type(value: "string")
        xml.documentation(value: "All Practitioners with last name matching value")
      end
    end
    xml.resource do
      xml.type(value: "Organization")
      xml.operation do
        xml.code(value: "read")
      end
      xml.operation do
        xml.code(value: "search-type")
        xml.documentation(value: "No search criteria leads to all organizations beings returned")
      end
      xml.searchParam do
        xml.name(value: "_id")
        xml.type(value: "string")
        xml.documentation(value: "All Organizations with id")
      end
      xml.searchParam do
        xml.name(value: "name")
        xml.type(value: "string")
        xml.documentation(value: "All Organizations with first or last name matching value")
      end
    end
  end
end
