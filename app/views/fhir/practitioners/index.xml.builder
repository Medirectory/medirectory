xml << render(:partial => 'fhir/shared_elements/xml/bundle.xml.builder', locals: {
  link_to: @link_to,
  entities: @providers,
  total: @total,
  type: "practitioner"
})
