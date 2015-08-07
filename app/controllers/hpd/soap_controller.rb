require 'hpd/hpd'

module Hpd
  class SoapController < ApplicationController

    skip_before_filter :verify_authenticity_token

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
      @results = Hpd::Dsml::Parser.parse_batch(batch_request)
      @results.each do |result|
        case result[:type]
        when 'searchRequest'
          Rails.logger.debug result[:request_result][:query].inspect
          Rails.logger.debug result[:request_result][:params].inspect
          result[:providers] = Provider.where(result[:request_result][:query], *result[:request_result][:params]).limit(5)
        end
      end
      respond_to :soap
    end

    before_filter :dump_parameters
    def dump_parameters
      Rails.logger.debug request.headers["Content-Type"]
      # Rails.logger.debug request.body.read
    end

  end
end
