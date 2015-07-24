xml.dsml :SearchResultEntry do
  xml.dsml(:npi, provider.npi)
  xml.dsml(:firstName, provider.first_name)
  xml.dsml(:lastName, provider.last_name_legal_name)
end
