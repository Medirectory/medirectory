xml.feed(xmlns:"http://www.w3.org/2005/Atom") do
  xml.title "Search Result for param values: " + @params.to_s
  xml.link(rel: "self", href: @link_to[:self]) unless @link_to[:self].empty?
  xml.link(rel: "first", href: @link_to[:first]) unless @link_to[:first].empty?
  xml.link(rel: "previous", href: @link_to[:previous]) unless @link_to[:previous].nil?
  xml.link(rel: "next", href: @link_to[:next]) unless @link_to[:next].nil?
  xml.link(rel: "last", href: @link_to[:last]) unless @link_to[:last].nil?
  xml.link(rel: "fhir-base", href: @link_to[:fhir_base]) unless @link_to[:base].empty?
  #xml.tag!('os:totalResults', {"xmlns:os"=>"http://a9.com/-/spec/opensearch/1.1/", value: @total})
  xml.id @link_to[:self]
  xml.author do
    xml.name "Medirectory"
  end
  @providers.each do |provider|
    xml.entry do
      xml.title provider.first_name.to_s + " " + provider.middle_name.to_s + " " + provider.last_name_legal_name.to_s
      xml.id @link_to[:base] + Rails.application.routes.url_helpers.fhir_practitioner_path(provider.npi, format: :xml)
      xml.updated provider.last_update_date.to_s + "T00:00:00"
      xml.published (provider.npi_reactivation_date || provider.enumeration_date).to_s + "T00:00:00"
      xml.author do
        xml.name "National Plan & Provider Enumeration System"
        xml.uri "https://nppes.cms.hhs.gov"
      end
      xml.content do
        xml << render(:partial => 'fhir/practitioners/xml/practitioner.xml.builder', locals: { provider: provider })
        # xml << render(:partial => 'fhir/practitioners/xml/resource.xml.builder', locals: {
        #   reference: Rails.application.routes.url_helpers.fhir_practitioner_path(provider.npi, format: :xml),
        #   display: provider.first_name.to_s + " " + provider.last_name_legal_name.to_s})
      end
    end
  end
end
