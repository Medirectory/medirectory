module Api
  module V1
    module Fhir
      class PractitionersController < ApplicationController
        SERIALIZATION_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
             {taxonomy_licenses: {include: :taxonomy_code}}, :taxonomy_groups, :organizations ]
        LOAD_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
             {taxonomy_licenses: :taxonomy_code}, :taxonomy_groups, :organizations ]
        RESULTS_PER_PAGE = 10

        def index
          # Basic search functionality
          providers = if params[:q]
                        Provider.basic_search(searchable_content: params[:q])
                      elsif params[:fuzzy_q]
                        Provider.fuzzy_search(searchable_content: params[:fuzzy_q])
                      else
                        Provider.all
                      end

          # Layer advanced search parameters onto existing results
          if params[:name]
            providers = providers.basic_search(searchable_name: params[:name])
          end
          if params[:location]
            providers = providers.basic_search(searchable_location: params[:location])
          end
          if params[:taxonomy]
            providers = providers.basic_search(searchable_taxonomy: params[:taxonomy])
          end
          if params[:organization]
            providers = providers.basic_search(searchable_organization: params[:organization])
          end
          if params[:npi]
            providers = providers.where(npi: params[:npi])
          end

          # We want to provide a total in addition to a paginated subset of the results
          # Note: If we don't have query parameters (all results), this is quite slow; if we need this, see
          # http://stackoverflow.com/questions/16916633/if-postgresql-count-is-always-slow-how-to-paginate-complex-queries
          count = providers.size

          # Add a secondary order to break search rank ties (which seem to create indeterminism)
          providers = providers.order(:npi)

          providers = providers.includes(LOAD_INCLUDES)
          providers = providers.offset(params[:offset]).limit(RESULTS_PER_PAGE)
          @providers = providers
          respond_to do |format|
            format.xml { render "api/v1/fhir/practitioners/index.xml.builder" }
            format.json { render "api/v1/fhir/practitioners/index.json.jbuilder" }
          end
        end

        def show
          @provider = Provider.includes(LOAD_INCLUDES).find(params[:id])
          respond_to do |format|
            format.xml {render "api/v1/fhir/practitioners/show.xml.builder" }
            format.json { render "api/v1/fhir/practitioners/show.json.jbuilder" }
          end
        end
      end
    end
  end
end

