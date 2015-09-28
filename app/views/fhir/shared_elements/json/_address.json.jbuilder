json.resourceType "Address"
json.use "work"
json.text address.first_line.to_s + (address.second_line.to_s.blank? ?  "": ", ") + address.second_line.to_s + ", " + address.city.to_s + ", " + address.state.to_s + ", " + address.postal_code.to_s + ", " + address.country_code.to_s
lines = []
lines << address.first_line if address.first_line
lines << address.second_line if address.second_line
json.line lines
json.city address.city
json.state address.state
json.postalCode address.postal_code
json.country address.country_code
