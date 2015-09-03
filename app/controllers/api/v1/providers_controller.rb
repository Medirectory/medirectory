module Api
  module V1

    class ProvidersController < ApplicationController
      SERIALIZATION_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
           {taxonomy_licenses: {include: :taxonomy_code}}, :taxonomy_groups, :organizations, :electronic_services ]
      RESULTS_PER_PAGE = 10

      # Method descriptions at https://github.com/Apipie/apipie-rails#id16
      api :GET, 'api/v1/providers', "Returns paginated results of a user-submitted search query. Will return all results if no parameters specified."
      description 'All parameters are optional, and can be combined to create more complex searches. If multiple search parameters are supplied they are combined using an implicit AND operator. Any parameter that accepts a string can use the following special search terms:

      OR: return results that match either term; example: `location=chicago+OR+miami`

      AND: return results that match both terms; example: `name=lee+AND+johnathan`

      NOT: return results that do not match the term; example: `location=NOT+baltimore`

      *: wildcard character for partial matching; example: `name=carruthe*`'
      formats ['json', 'xml']
      error :code => 400, :desc => "Bad Request"
      example '{ error : "Invalid Query Syntax" }'
      example '
      {
        "meta":  {
          "totalResults": 1,
          "resultsPerPage": 10
        },
        "providers":  [
          {
            "npi": "[NPI]",
            "last_name_legal_name": "[LAST NAME]",
            "first_name": "[FIRST NAME]",
            "gender_code": "F",
            "mailing_address": {
              "first_line": "[ADDRESS]",
              "second_line": "[ADDRESS]",
              "city": "[CITY]",
              "state": "[STATE]",
              "postal_code": "[ZIP]",
              "country_code": "[COUNTRY]",
              "telephone_number": "[PHONE NUMBER]"
            },
            "practice_location_address": {
              "first_line": "[ADDRESS]",
              "second_line": "[ADDRESS]",
              "city": "[CITY]",
              "state": "[STATE]",
              "postal_code": "[ZIP]",
              "country_code": "[COUNTRY]",
              "telephone_number": "[PHONE NUMBER]"
            },
            "taxonomy_licenses": [
              {
                "code": "[CODE]",
                "taxonomy_code": {
                  "code": "[CODE]",
                  "taxonomy_type": "[TYPE]",
                  "classification": "[CLASSIFICATION]"
                }
              }
            ]
          }
        ]
      }'
      # Parameter descriptions at https://github.com/Apipie/apipie-rails#id17
      param :q,             String,   :desc => "Specifies a search on a generic search query that searches across all available fields (NPI, name, location, specialization, organization name). "
      param :offset,        :number,  :desc => "Defaults to 0. Enables paginated search."
      param :name,          String,   :desc => "Specifies a search on the name of a provider."
      param :location,      String,   :desc => "Specifies a search on the location, specified as a state or city."
      param :taxonomy,      String,   :desc => "Specifies a search on the taxonomy, or speciality, associated with a provider."
      param :organization,  String,   :desc => "Specifies a search on the organization associated with a provider."
      param :npi,           String,   :desc => "Specifies a search on a National Provider Identifier."
      param :latitude,      :number,   :desc => "Provided by geolocation."
      param :longitude,     :number,   :desc => "Provided by geolocation."
      param :radius,        :number,  :desc => "Specifies a search for providers within a specified radius in miles of the provided latitude and longitude or geo_zip. If no radius is provided, a default of 1 mile is used."
      param :geo_zip,       String,   :desc => "A zip code to search against."
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
        if params[:gender]
          providers = providers.where(gender_code: params[:gender])
        end
        if params[:latitude] and params[:longitude]
          radius = (params[:radius] || '1').to_f
          radius = radius * 1609.34
          providers = providers.within_radius(params[:latitude].to_f, params[:longitude].to_f, radius)
        elsif params[:geo_zip]
          radius = (params[:radius] || '1').to_f
          radius = radius * 1609.34
          zip_translation = ZipCode.find_by(postal_code: params[:geo_zip])
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

      api :GET, 'api/v1/providers/:id', "Returns a single provider record."
      formats ['json', 'xml']
      param :id, :number
      example '
      {
        provider: {
          "npi": "[NPI]",
          "last_name_legal_name": "[LAST NAME]",
          "first_name": "[FIRST NAME]",
          "gender_code": "F",
          "mailing_address": {
            "first_line": "[ADDRESS]",
            "second_line": "[ADDRESS]",
            "city": "[CITY]",
            "state": "[STATE]",
            "postal_code": "[ZIP]",
            "country_code": "[COUNTRY]",
            "telephone_number": "[PHONE NUMBER]"
          },
          "practice_location_address": {
            "first_line": "[ADDRESS]",
            "second_line": "[ADDRESS]",
            "city": "[CITY]",
            "state": "[STATE]",
            "postal_code": "[ZIP]",
            "country_code": "[COUNTRY]",
            "telephone_number": "[PHONE NUMBER]"
          },
          "taxonomy_licenses": [
            {
              "code": "[CODE]",
              "taxonomy_code": {
                "code": "[CODE]",
                "taxonomy_type": "[TYPE]",
                "classification": "[CLASSIFICATION]"
              }
            }
          ],
          "taxonomy_groups": ".",
          "organizations": [
            {
              ...
            }
          ],
          "electronic_services": [
            {
              ...
            }
          ]
        }
      }'
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
