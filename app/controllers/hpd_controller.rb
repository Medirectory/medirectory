require 'hpd/hpd'

class HpdController < ApplicationController

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
        case result[:request_result][:search_type]
        when 'HcProfessional'
          result[:providers] = Provider.where(result[:request_result][:query], *result[:request_result][:params]).order(:npi).limit(5)
        when 'HcRegulatedOrganization'
          result[:orgs] = Organization.where(result[:request_result][:query], *result[:request_result][:params]).order(:npi).limit(5)
        end
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
