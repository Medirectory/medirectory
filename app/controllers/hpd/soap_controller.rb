require 'hpd/hpd'

module Hpd
  class SoapController < ApplicationController

    skip_before_filter :verify_authenticity_token

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
      batch_request = soap_message.xpath("//dsml:batchRequest", "dsml" => Hpd::Dsml::XMLNS)
      # parse_batch(batch_request)
      query_string = Hpd::Dsml::Parser.parse_batch(batch_request)
      @providers = Provider.where(query[:query], query[:params]).limit(10)
      respond_to :soap
    end

    before_filter :dump_parameters
    def dump_parameters
      Rails.logger.debug request.headers["Content-Type"]
      # Rails.logger.debug request.body.read
    end

  end
end
