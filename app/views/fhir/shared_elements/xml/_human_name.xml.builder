xml.use(value: code)
xml.text(value: prefix.to_s + (prefix.to_s.blank? ?  "": " ") + first_name.to_s+ " " + middle_name.to_s + (middle_name.to_s.blank? ?  "": " ") + last_name.to_s + (suffix.to_s.blank? ?  "": " ") + suffix.to_s)
xml.family(value: last_name) if last_name
xml.given(value: first_name) if first_name
xml.given(value: middle_name) if middle_name
xml.prefix(value: prefix) if prefix
xml.suffix(value: suffix) if suffix
