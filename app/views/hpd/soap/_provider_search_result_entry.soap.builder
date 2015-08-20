xml.dsml(:searchResultEntry, dn: "") do
  xml.dsml(:attr, name: "givenName") do
    xml.dsml(:value, provider.first_name)
  end
  xml.dsml(:attr, name: "sn") do
    xml.dsml(:value, provider.last_name_legal_name)
  end
  xml.dsml(:attr, name: "pager")
  xml.dsml(:attr, name: "uid")
  xml.dsml(:attr, name: "mail")
  xml.dsml(:attr, name: "hpdproviderlegaladdress")
  xml.dsml(:attr, name: "hcspecialisation") do
    xml.dsml(:value, provider.taxonomy_licenses.first.taxonomy_code.specialization)
  end
  xml.dsml(:attr, name: "hpdproviderlanguagesupported")
  xml.dsml(:attr, name: "hpdproviderpracticeaddress") do
    phys_addr = provider.practice_location_address
    phys_addr_str = phys_addr.first_line + " " + phys_addr.second_line.to_s + ", " + phys_addr.city + ", " + phys_addr.state + " " + phys_addr.postal_code
    xml.dsml(:value, phys_addr_str)
  end
  xml.dsml(:attr, name: "telephonenumber") do
    xml.dsml(:value, provider.practice_location_address.telephone_number)
  end
  xml.dsml(:attr, name: "facsimiletelephonenumber") do
    xml.dsml(:value, provider.practice_location_address.fax_number)
  end
  xml.dsml(:attr, name: "cn")
  xml.dsml(:attr, name: "initials")
  xml.dsml(:attr, name: "description")
  xml.dsml(:attr, name: "hcprofession") do
    xml.dsml(:value, provider.taxonomy_licenses.first.taxonomy_code.classification)
  end
  xml.dsml(:attr, name: "hpdproviderbillingaddress")
  xml.dsml(:attr, name: "objectclass")
  xml.dsml(:attr, name: "hpdhasaservice")
  xml.dsml(:attr, name: "hpdprovidermailingaddress") do
    mailing_addr = provider.mailing_address
    mailing_addr_str = mailing_addr.first_line + " " + mailing_addr.second_line.to_s + ", " + mailing_addr.city + ", " + mailing_addr.state + " " + mailing_addr.postal_code
    xml.dsml(:value, mailing_addr_str)
  end
  xml.dsml(:attr, name: "hcidentifier")
  xml.dsml(:attr, name: "mobile")
  xml.dsml(:attr, name: "title") do
    xml.dsml(:value, provider.name_prefix)
  end
  xml.dsml(:attr, name: "gender") do
    xml.dsml(:value, provider.gender_code)
  end
  xml.dsml(:attr, name: "hpdcredential") do
    xml.dsml(:value, provider.credential)
  end
  xml.dsml(:attr, name: "hpdproviderstatus")
end
