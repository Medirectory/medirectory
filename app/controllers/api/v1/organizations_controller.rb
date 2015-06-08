module Api
  module V1

    class OrganizationsController < ApplicationController
      @@to_include = [:mailing_address, :practice_location_address, :other_provider_identifiers,
            :taxonomy_licenses, :taxonomy_groups ]

      def index
        organizations = if params[:q]
                          Organization.basic_search(params[:q])
                        elsif params[:fuzzy_q]
                          Organization.fuzzy_search(params[:fuzzy_q])
                        else
                          Organization.all
                        end
        organizations = organizations.offset(params[:offset]).limit(20)
        respond_to do |format|
          format.xml { render xml: organizations, 
            :include => @@to_include }
          format.json { render json: organizations}
        end
      end

      def show
        organization = Organization.find(params[:id])
        respond_to do |format|
          format.xml { render xml: organization, 
            :include => @@to_include}
          format.json { render json: organization}
        end
      end

    end

  end
end
