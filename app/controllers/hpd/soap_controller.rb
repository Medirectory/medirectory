module Hpd
  class SoapController < ApplicationController

    skip_before_filter :verify_authenticity_token

    DSML = "urn:oasis:names:tc:DSML:2:0:core"

    LOOKUP_TEXT = { 
      givenName: "first_name", 
      sn: "last_name_legal_name",
      # o: "organization_name_legal_business_name" 
    }

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
      query = parse(filter.children.first)
      @providers = Provider.where(query[:query], query[:params]).limit(10)
      # Figured this out!!
      # @organizations = Organization.where(query[:query], query[:params]).limit(10)
    end

    def parse (element)
      case element.name
      when "equalityMatch"
        name = element.attr(:name)
        value = element.text.upcase
        {
          query: LOOKUP_TEXT[name.intern] + ' = :' + name,
          params: {name.intern => value}
        }
      when "and"
        allQueries = []
        allParams = {}
        element.children.each do |child|
          # combine the seperate parsed children with and merge params
          values = parse(child)
          allQueries.push(values[:query])
          allParams = allParams.merge(values[:params])
        end
        {
          query: '(' + allQueries.join(' AND ') + ')',
          params: allParams
        }
      else
        {
          query: "",
          params: {}
        }
      end
    end
  end
end
