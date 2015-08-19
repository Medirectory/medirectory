xml.dsml(:searchResultEntry, dn: "") do
  xml.dsml(:attr, name: "hcIdentifier")
  xml.dsml(:attr, name: "o") do
    xml.dsml(:value, org.organization_name_legal_business_name)
  end
  xml.dsml(:attr, name: "businessCategory")
  xml.dsml(:attr, name: "hcRegisteredName")
  xml.dsml(:attr, name: "description")
  xml.dsml(:attr, name: "hpdProviderStatus")
  xml.dsml(:attr, name: "clinicalInformationContact")
  xml.dsml(:attr, name: "hpdProviderMailingAddress") do
    mailing_addr = org.mailing_address
    mailing_addr_str = mailing_addr.first_line + " " + mailing_addr.second_line.to_s + ", " + mailing_addr.city + ", " + mailing_addr.state + " " + mailing_addr.postal_code
    xml.dsml(:value, mailing_addr_str)
  end
  xml.dsml(:attr, name: "hpdProviderBillingAddress")
  xml.dsml(:attr, name: "hpdProviderPracticeAddress") do
    phys_addr = org.practice_location_address
    phys_addr_str = phys_addr.first_line + " " + phys_addr.second_line.to_s + ", " + phys_addr.city + ", " + phys_addr.state + " " + phys_addr.postal_code
    xml.dsml(:value, phys_addr_str)
  end
  xml.dsml(:attr, name: "hpdProviderLanguageSupported")
  xml.dsml(:attr, name: "hcSpecialization")
  xml.dsml(:attr, name: "telephoneNumber") do
    xml.dsml(:value, org.practice_location_address.telephone_number)
  end
  xml.dsml(:attr, name: "facsimileTelephoneNumber") do
    xml.dsml(:value, org.practice_location_address.fax_number)
  end
  xml.dsml(:attr, name: "hpdHasAService")
  xml.dsml(:attr, name: "mail")
  xml.dsml(:attr, name: "policyInformation")
  xml.dsml(:attr, name: "hpdOrgId")
end
