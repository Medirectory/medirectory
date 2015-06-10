module Api
  module V1

    class ProvidersController < ApplicationController
      SERIALIZATION_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
            :taxonomy_licenses, :taxonomy_groups ]

      def index
        providers = if params[:q]
                      Provider.basic_search(searchable_content: params[:q])
                    elsif params[:fuzzy_q]
                      Provider.fuzzy_search(searchable_content: params[:fuzzy_q])
                    else
                      Provider.all
                    end
        providers = providers.offset(params[:offset]).limit(20)
        respond_to do |format|
          format.xml { render xml: providers, 
            :include => SERIALIZATION_INCLUDES}
          format.json { render json: providers}
        end
      end

      def show
        provider = Provider.find(params[:id])
        respond_to do |format|
          format.xml { render xml: provider, 
            :include => SERIALIZATION_INCLUDES }
          format.json { render json: provider}
        end
      end

    end

  end
end
