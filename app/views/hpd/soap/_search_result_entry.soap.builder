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
  xml.dsml(:attr, name: "hcspecialisation")
  xml.dsml(:attr, name: "hpdproviderlanguagesupported")
  xml.dsml(:attr, name: "hpdproviderpracticeaddress")
  xml.dsml(:attr, name: "telephonenumber")
  xml.dsml(:attr, name: "facsimiletelephonenumber")
  xml.dsml(:attr, name: "cn")
  xml.dsml(:attr, name: "initials")
  xml.dsml(:attr, name: "description")
  xml.dsml(:attr, name: "hcprofession")
  xml.dsml(:attr, name: "hpdproviderbillingaddress")
  xml.dsml(:attr, name: "objectclass")
  xml.dsml(:attr, name: "hpdhasaservice")
  xml.dsml(:attr, name: "hpdprovidermailingaddress")
  xml.dsml(:attr, name: "hcidentifier")
  xml.dsml(:attr, name: "mobile")
  xml.dsml(:attr, name: "title")
  xml.dsml(:attr, name: "gender")
  xml.dsml(:attr, name: "hpdcredential")
  xml.dsml(:attr, name: "hpdproviderstatus")
end
