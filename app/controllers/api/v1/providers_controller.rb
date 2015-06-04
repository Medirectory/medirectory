module Api
  module V1

    class ProvidersController < ApplicationController

      def show
        provider = Provider.find(params[:id])
        toInclude = [:mailing_address, :practice_location_address, :other_provider_identifiers,
            :taxonomy_licenses, :taxonomy_groups ]
        respond_to do |format|
          format.xml { render xml: provider, 
            :include => toInclude}
          format.json { render json: provider, 
            :include => toInclude}
        end
      end

    end

  end
end
