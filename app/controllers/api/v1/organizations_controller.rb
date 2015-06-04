module Api
  module V1

    class OrganizationsController < ApplicationController

      def show
        organization = Organization.find(params[:id])
        respond_to do |format|
          format.xml { render xml: organization, 
            :include => [:mailing_address, :practice_location_address, :other_provider_identifiers,
            :taxonomy_licenses, :taxonomy_groups ]}
          format.json { render json: organization, 
            :include => [:mailing_address, :practice_location_address, :other_provider_identifiers,
            :taxonomy_licenses, :taxonomy_groups ]}
        end
      end

    end

  end
end
