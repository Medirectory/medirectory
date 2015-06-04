module Api
  module V1

    class ProvidersController < ApplicationController

      def show
        provider = Provider.find(params[:id])
        respond_to do |format|
          format.xml { render xml: provider, 
            :include => [:mailing_address, :practice_location_address, :other_provider_identifiers,
            :taxonomy_licenses, :taxonomy_groups ]}
          format.json { render json: provider, 
            :include => [:mailing_address, :practice_location_address, :other_provider_identifiers,
            :taxonomy_licenses, :taxonomy_groups ]}
        end
      end

    end

  end
end
