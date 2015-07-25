module Api
  module V1

    class OrganizationsController < ApplicationController
      SERIALIZATION_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
           {taxonomy_licenses: {include: :taxonomy_code}}, :taxonomy_groups,
           {providers: {include: {taxonomy_licenses: {include: :taxonomy_code}}}} ]
      LOAD_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
           {taxonomy_licenses: :taxonomy_code}, :taxonomy_groups,
           {providers: {taxonomy_licenses: :taxonomy_code}} ]
      RESULTS_PER_PAGE = 10

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
        if params[:latitude] and params[:longitude]
          organizations = organizations.within_radius(params[:latitude].to_f, params[:longitude].to_f, 5000)
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
