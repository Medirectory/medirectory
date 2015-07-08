class Api::V1::HpdController < ApplicationController
  soap_service namespace: 'urn:ihe:iti:hpd:2010',
                wsdl_style: 'document'

  soap_action "integer_to_string",
              :args   => :integer,
              :return => :string

  def integer_to_string
    # render :soap => params[:value].to_s
    render :soap => params[:value].to_s
  end

  soap_action "ProviderInformationQueryRequestMessage",
              :args => :xml,
              :return => nil,
              :to => :provider_information_query

  def provider_information_query
    render :soap => nil
  end

  before_filter :dump_parameters
  def dump_parameters
    Rails.logger.debug params.inspect
  end

end
