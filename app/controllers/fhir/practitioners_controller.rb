module Fhir
  class PractitionersController < ApplicationController
    LOAD_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
         {taxonomy_licenses: :taxonomy_code}, :taxonomy_groups, :organizations ]
    RESULTS_PER_PAGE = 3

    def index
      # Basic search functionality
      providers = Provider.all

      # Add a secondary order to break search rank ties (which seem to create indeterminism)
      providers = providers.order(:npi)
      if params[:name]
        providers = providers.complex_search(searchable_name: params[:name])
      end
      @total = providers.size
      providers = providers.includes(LOAD_INCLUDES)
      providers = providers.offset(params[:offset]).limit(RESULTS_PER_PAGE)
      @providers = providers
      @params = params.except(:action, :controller, :format)
      original_offset = @params[:offset]
      offset = params[:offset].to_i || 0
      @link_to = {
        self: request.original_url,
        fhir_base: request.protocol + request.host_with_port + "/fhir",
        base: request.protocol + request.host_with_port + "/"
      }
      @link_to[:previous] = if (offset-RESULTS_PER_PAGE) >= 0
        @params[:offset] = (offset-RESULTS_PER_PAGE).to_s
        request.original_url.split('?').first + "?" + @params.to_query
      end
      @link_to[:next] = if (offset+RESULTS_PER_PAGE) < @total
        @params[:offset] = (offset+RESULTS_PER_PAGE).to_s
        request.original_url.split('?').first + "?" + @params.to_query
      end
      @link_to[:last] = if @total > RESULTS_PER_PAGE
        @params[:offset] = (@total-@total%RESULTS_PER_PAGE).to_s
        request.original_url.split('?').first + "?" + @params.to_query
      end
      @link_to[:first] = request.original_url.split('?').first
      @link_to[:first] = @link_to[:first] + "?" + @params.except(:offset).to_query unless @params.except(:offset).empty?

      # Handles the _format case where the fhir user enters their format manually
      case @params[:_format]
      when "json"
        render "index.json"
      when "xml"
        render "index.xml"
      end
    end

    def show
      @provider = Provider.includes(LOAD_INCLUDES).find(params[:id])
      case params[:_format]
      when "json"
        render "show.json"
      when "xml"
        render "show.xml"
      end
    end
  end
end
