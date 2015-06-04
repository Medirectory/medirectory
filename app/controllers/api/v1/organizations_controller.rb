module Api
  module V1

    class OrganizationsController < ApplicationController

      def show
        organization = Organization.find(params[:id])
        to_include = [:mailing_address, :practice_location_address, :other_provider_identifiers,
            :taxonomy_licenses, :taxonomy_groups ]
        respond_to do |format|
          format.xml { render xml: organization, 
            :include => to_include}
          format.json { render json: organization, 
            :include => to_include}
        end
      end

    end

  end
end
