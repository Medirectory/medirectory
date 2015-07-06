json.use "work"
json.text address.first_line.to_s + (address.second_line.to_s.blank? ?  "": ", ") + address.second_line.to_s + ", " + address.city.to_s + ", " + address.state.to_s + ", " + address.postal_code.to_s + ", " + address.country_code.to_s
json.line address.first_line.to_s + (address.second_line.to_s.blank? ?  "": ", ") + address.second_line.to_s
json.city address.city
json.state address.state 
json.zip address.postal_code 
json.country address.country_code