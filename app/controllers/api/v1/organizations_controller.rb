module Api
  module V1

    class OrganizationsController < ApplicationController
      SERIALIZATION_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
           {taxonomy_licenses: {include: :taxonomy_code}}, :taxonomy_groups ]

      def index
        organizations = if params[:q]
                          Organization.basic_search(searchable_name: params[:q])
                        elsif params[:fuzzy_q]
                          Organization.fuzzy_search(searchable_name: params[:fuzzy_q])
                        else
                          Organization.all
                        end
        organizations = organizations.includes(SERIALIZATION_INCLUDES)
        organizations = organizations.offset(params[:offset]).limit(20)
        respond_to do |format|
          format.xml { render xml: organizations, include: SERIALIZATION_INCLUDES }
          format.json { render json: MultiJson.encode(organizations: organizations.as_json(include: SERIALIZATION_INCLUDES)) }
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
