module Fhir
  class PractitionersController < ApplicationController
    LOAD_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
         {taxonomy_licenses: :taxonomy_code}, :taxonomy_groups, :organizations ]
    RESULTS_PER_PAGE = 10

    def index
      # Basic search functionality
      providers = Provider.all

      # Add a secondary order to break search rank ties (which seem to create indeterminism)
      providers = providers.order(:npi)

      providers = providers.includes(LOAD_INCLUDES)
      providers = providers.offset(params[:offset]).limit(RESULTS_PER_PAGE)
      @providers = providers

      # Handles the _format case where the fhir user enters their format manually
      case params[:_format]
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
