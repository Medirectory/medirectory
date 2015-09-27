json.resourceType "HumanName"
json.use code
json.text prefix.to_s + (prefix.to_s.blank? ?  "": " ") + first_name.to_s+ " " + middle_name.to_s + (middle_name.to_s.blank? ?  "": " ") + last_name.to_s + (suffix.to_s.blank? ?  "": " ") + suffix.to_s
json.family [last_name]
given_names = []
given_names << first_name if first_name
given_names << middle_name if middle_name
json.given given_names
json.prefix [prefix] if prefix
json.suffix [suffix] if suffix
