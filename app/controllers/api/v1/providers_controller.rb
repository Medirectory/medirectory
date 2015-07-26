module Api
  module V1

    class ProvidersController < ApplicationController
      SERIALIZATION_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
           {taxonomy_licenses: {include: :taxonomy_code}}, :taxonomy_groups, :organizations ]
      RESULTS_PER_PAGE = 10

      def index

        # Basic search functionality
        providers = if params[:q]
                      Provider.complex_search(searchable_content: params[:q])
                    elsif params[:fuzzy_q]
                      Provider.fuzzy_search(searchable_content: params[:fuzzy_q])
                    else
                      Provider.all
                    end

        # Layer advanced search parameters onto existing results
        if params[:name]
          providers = providers.complex_search(searchable_name: params[:name])
        end
        if params[:location]
          providers = providers.complex_search(searchable_location: params[:location])
        end
        if params[:taxonomy]
          providers = providers.complex_search(searchable_taxonomy: params[:taxonomy])
        end
        if params[:organization]
          providers = providers.complex_search(searchable_organization: params[:organization])
        end
        if params[:npi]
          providers = providers.where(npi: params[:npi])
        end
        if params[:latitude] and params[:longitude]
          radius = params[:radius].to_i
          radius ||= 5000
          providers = providers.within_radius(params[:latitude].to_f, params[:longitude].to_f, radius)
        elsif params[:geo_zip]
          radius = params[:radius].to_i
          radius ||= 5000
          zip_translation = ZipCode.find_by(postal_code: params[:geo_zip].to_i)
          providers = providers.within_radius(zip_translation[:latitude].to_f, zip_translation[:longitude].to_f, radius)
        end

        # We want to provide a total in addition to a paginated subset of the results
        # Note: If we don't have query parameters (all results), this is quite slow; if we need this, see
        # http://stackoverflow.com/questions/16916633/if-postgresql-count-is-always-slow-how-to-paginate-complex-queries
        count = providers.size

        # Add a secondary order to break search rank ties (which seem to create indeterminism)
        providers = providers.order(:npi)

        #providers = providers.includes(LOAD_INCLUDES)
        providers = providers.offset(params[:offset]).limit(RESULTS_PER_PAGE)

        respond_to do |format|
          format.xml { render xml: providers, include: SERIALIZATION_INCLUDES }
          format.json { render json: MultiJson.encode(meta: { totalResults: count, resultsPerPage: RESULTS_PER_PAGE },
                                                      providers: providers.as_json(include: SERIALIZATION_INCLUDES))}
        end

      rescue ActiveRecord::StatementInvalid

        # We wind up here if the search query is invalid, return a 400 error code (Bad Request)
        respond_to do |format|
          format.xml { render status: :bad_request, xml: { error: 'Invalid Query Syntax' } }
          format.json { render status: :bad_request, json: { error: 'Invalid Query Syntax' } }
        end

      end

      def show
        provider = Provider.find(params[:id])
        respond_to do |format|
          format.xml { render xml: provider, include: SERIALIZATION_INCLUDES }
          format.json { render json: MultiJson.encode(provider: provider.as_json(include: SERIALIZATION_INCLUDES)) }
        end
      end

    end

  end
end
