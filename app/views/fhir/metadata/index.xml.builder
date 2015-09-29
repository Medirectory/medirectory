xml.Conformance(xmlns:"http://hl7.org/fhir") do
  xml.publisher(value: "MITRE")
  xml.date(value: "2015-09-29T09:08:29.499-04:00")
  xml.description(value: "Test implementation of the FHIR markup for our database")
  # xml.experimental(value: "true")
  xml.kind(value: "capability")
  xml.fhirVersion(value: "2.0.0")
  xml.acceptUnknown(value: "no")
  xml.format(value: "xml")
  xml.format(value: "xml")
  xml.rest do
    xml.mode(value: "server")
    xml.resource do
      xml.type(value: "Practitioner")
      xml.interaction do
        xml.code(value: "read")
      end
      xml.interaction do
        xml.code(value: "search-type")
        xml.documentation(value: "No search criteria leads to all Practitioners beings returned")
      end
      xml.searchParam do
        xml.name(value: "_id")
        xml.type(value: "token")
        xml.documentation(value: "All Practitioners with id")
      end
      xml.searchParam do
        xml.name(value: "name")
        xml.type(value: "string")
        xml.documentation(value: "All Practitioners with first or last name matching value")
        xml.modifier(value: "exact")
        xml.modifier(value: "contains")
        xml.modifier(value: "missing")
      end
      xml.searchParam do
        xml.name(value: "given_name")
        xml.type(value: "string")
        xml.documentation(value: "All Practitioners with first name matching value")
        xml.modifier(value: "exact")
        xml.modifier(value: "contains")
        xml.modifier(value: "missing")
      end
      xml.searchParam do
        xml.name(value: "family_name")
        xml.type(value: "string")
        xml.documentation(value: "All Practitioners with last name matching value")
        xml.modifier(value: "exact")
        xml.modifier(value: "contains")
        xml.modifier(value: "missing")
      end
    end
    xml.resource do
      xml.type(value: "Organization")
      xml.interaction do
        xml.code(value: "read")
      end
      xml.interaction do
        xml.code(value: "search-type")
        xml.documentation(value: "No search criteria leads to all organizations beings returned")
      end
      xml.searchParam do
        xml.name(value: "_id")
        xml.type(value: "token")
        xml.documentation(value: "All Organizations with id")
      end
      xml.searchParam do
        xml.name(value: "name")
        xml.type(value: "string")
        xml.documentation(value: "All Organizations with first or last name matching value")
        xml.modifier(value: "exact")
        xml.modifier(value: "contains")
        xml.modifier(value: "missing")
      end
    end
  end
end
