module Hpd
  class SoapController < ApplicationController

    skip_before_filter :verify_authenticity_token

    DSML = "urn:oasis:names:tc:DSML:2:0:core"

    lookup_text = { givenName: "first_name", sn: "last_name_legal_name" }

    def wsdl
      respond_to :wsdl
    end

    def endpoint
      # default SOAP action
      soap_message = Nokogiri::XML(request.body.read) do |config|
        config.noblanks
      end
      batch_request = soap_message.xpath("//dsml:batchRequest", "dsml" => DSML)
      parse_batch(batch_request)
      respond_to :soap
    end

    before_filter :dump_parameters
    def dump_parameters
      Rails.logger.debug request.headers["Content-Type"]
      # Rails.logger.debug request.body.read
    end

    private

    def validate_dsml (soap_body)
      schema = Nokogiri::XML::Schema(File.read("#{Rails.root}/public/schema/DSML/DSMLv2.xsd"))
      errors = schema.validate(soap_body).map{|e| e.message}.join(", ")
      raise(StandardError, errors) unless errors.empty?
    end

    # TODO: handle undefined methods (i.e addRequest)
    def parse_batch (batch_request)
      batch_request.children.each do |request|
        send(request.name.underscore, request)
      end
    end

    def search_request (request)
      filter = request.xpath("//dsml:filter", "dsml" => DSML)
      query = parse (filter.first_element_child)
      @providers = Provider.where(query.query, query.params).limit(10)
    end

    def parse (element)
      vals = case element.name
             when "equalityMatch"
               {
                 query: lookup_text[element.attr(:name).text().intern] + ' = :' + element.attr(:name).text,
                 params: {element.attr(:name).text().intern => element.attr(:value).text}
               }
             else
               {
                 query: "",
                 params: {}
               }
             end
      return { query: '('+vals.query+')', params: vals.params }
    end

  end
end
