xml.use(value: "work" )
xml.text(value: address.first_line.to_s+ (address.second_line.to_s.blank? ?  "": ", ") + address.second_line.to_s + ", " + address.city.to_s + ", " + address.state.to_s + ", " + address.postal_code.to_s + ", " + address.country_code.to_s )
xml.line(value: address.first_line) if address.first_line
xml.line(value: address.second_line) if address.second_line
xml.city(value: address.city )
xml.state(value: address.state )
xml.zip(value: address.postal_code )
xml.country(value: address.country_code )
