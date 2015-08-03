module Hpd
  class SoapController < ApplicationController

    skip_before_filter :verify_authenticity_token

    DSML = "urn:oasis:names:tc:DSML:2:0:core"

    def wsdl
      respond_to :wsdl
    end

    def endpoint
      # default SOAP action
      soap_message = Nokogiri::XML(request.body.read)
      search_value = soap_message.xpath("//dsml:searchRequest/dsml:filter/dsml:equalityMatch/dsml:value/text()", "dsml" => DSML)
      @providers = Provider.where(first_name: search_value.to_s.upcase).limit(10)
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

  end
end
