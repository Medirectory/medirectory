module Api
  module V1

    class OrganizationsController < ApplicationController
      SERIALIZATION_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
           {taxonomy_licenses: {include: :taxonomy_code}}, :taxonomy_groups, :electronic_services,
           {providers: {include: {taxonomy_licenses: {include: :taxonomy_code}}}} ]
      RESULTS_PER_PAGE = 10

      api :GET, 'api/v1/organizations', "Returns paginated results of a user-submitted search query. Will return all results if no parameters specified."
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
        "organizations":  [
          {
            "npi": "[NPI]",
            "organization_name_legal_business_name": "[LEGAL NAME]",
            "other_organization_name": "[OTHER NAME]",
            "authorized_official_last_name": "[LAST NAME]",
            "authorized_official_first_name": "[FIRST NAME]",
            "authorized_official_telephone_number": "[PHONE NUMBER]",
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
            "other_provider_identifiers": [
              {
                "identifier": "[IDENTIFIER]",
                "identifier_type_code": "[CODE]",
                "identifier_state": "[STATE]"
              }
            ]
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
      param :q,             String,   :desc => "Specifies a search on a generic search query that searches across all available fields (NPI, name, location, specialization, provider name). "
      param :offset,        :number,  :desc => "Defaults to 0. Enables paginated search."
      param :name,          String,   :desc => "Specifies a search on the name of an organization."
      param :authorized_official,  String,   :desc => "Specifies a search on the authorized official of an organization."
      param :location,      String,   :desc => "Specifies a search on the location, specified as a state or city."
      param :taxonomy,      String,   :desc => "Specifies a search on the taxonomy, or speciality, associated with an organization."
      param :npi,           String,   :desc => "Specifies a search on a National Provider Identifier."
      param :latitude,      :number,   :desc => "Provided by geolocation."
      param :longitude,     :number,   :desc => "Provided by geolocation."
      param :radius,        :number,  :desc => "Specifies a search for organizations within a specified radius in miles of the provided latitude and longitude or geo_zip. If no radius is provided, a default of 1 mile is used."
      param :geo_zip,       String,   :desc => "A zip code to search against."
      def index
        # Basic search functionality
        organizations = if params[:q]
                          Organization.basic_search(searchable_content: params[:q])
                        elsif params[:fuzzy_q]
                          Organization.fuzzy_search(searchable_content: params[:fuzzy_q])
                        else
                          Organization.all
                        end

        # Layer advanced search parameters onto existing results
        if params[:name]
          organizations = organizations.basic_search(searchable_name: params[:name])
        end
        if params[:authorized_official]
          organizations = organizations.basic_search(searchable_authorized_official: params[:authorized_official])
        end
        if params[:location]
          organizations = organizations.basic_search(searchable_location: params[:location])
        end
        if params[:taxonomy]
          organizations = organizations.basic_search(searchable_taxonomy: params[:taxonomy])
        end
        if params[:provider]
          organizations = organizations.basic_search(searchable_providers: params[:provider])
        end
        if params[:npi]
          organizations = organizations.where(npi: params[:npi])
        end
        if params[:latitude] and params[:longitude] and params[:radius]
          radius = (params[:radius] || '1').to_f
          radius = radius * 1609.34
          organizations = organizations.within_radius(params[:latitude].to_f, params[:longitude].to_f, params[:radius].to_i)
        elsif params[:geo_zip]
          radius = (params[:radius] || '1').to_f
          radius = radius * 1609.34
          zip_translation = ZipCode.find_by(postal_code: params[:geo_zip])
          organizations = organizations.within_radius(zip_translation[:latitude].to_f, zip_translation[:longitude].to_f, radius)
        end

        # We want to provide a total in addition to a paginated subset of the results
        count = organizations.size

        #organizations = organizations.includes(LOAD_INCLUDES)
        organizations = organizations.offset(params[:offset]).limit(RESULTS_PER_PAGE)

        respond_to do |format|
          format.xml { render xml: organizations, include: SERIALIZATION_INCLUDES }
          format.json { render json: MultiJson.encode(meta: { totalResults: count, resultsPerPage: RESULTS_PER_PAGE },
                                                      organizations: organizations.as_json(include: SERIALIZATION_INCLUDES)) }
        end
      end

      api :GET, 'api/v1/organizations/:id', "Returns a single organization record."
      formats ['json', 'xml']
      param :id, :number
      example '
      {
        "organization":  [
          {
            "npi": "[NPI]",
            "organization_name_legal_business_name": "[LEGAL NAME]",
            "other_organization_name": "[OTHER NAME]",
            "authorized_official_last_name": "[LAST NAME]",
            "authorized_official_first_name": "[FIRST NAME]",
            "authorized_official_telephone_number": "[PHONE NUMBER]",
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
            "other_provider_identifiers": [
              {
                "identifier": "[IDENTIFIER]",
                "identifier_type_code": "[CODE]",
                "identifier_state": "[STATE]"
              }
            ]
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
      def show
        organization = Organization.find(params[:id])
        respond_to do |format|
          format.xml { render xml: organization, include: SERIALIZATION_INCLUDES }
          format.json { render json: MultiJson.encode(organization: organization.as_json(include: SERIALIZATION_INCLUDES)) }
        end
      end

    end

  end
end
