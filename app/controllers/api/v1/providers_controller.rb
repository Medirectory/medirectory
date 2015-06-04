module Api
  module V1

    class ProvidersController < ApplicationController

      def index
        providers = if params[:q]
                      Provider.basic_search(params[:q])
                    elsif params[:fuzzy_q]
                      Provider.fuzzy_search(params[:fuzzy_q])
                    else
                      Provider.all
                    end
        providers = providers.offset(params[:offset]).limit(20)
        respond_to do |format|
          format.xml { render xml: providers }
          format.json { render json: providers }
        end
      end

      def show
        provider = Provider.find(params[:id])
        to_include = [:mailing_address, :practice_location_address, :other_provider_identifiers,
            :taxonomy_licenses, :taxonomy_groups ]
        respond_to do |format|
          format.xml { render xml: provider, 
            :include => to_include}
          format.json { render json: provider, 
            :include => to_include}
        end
      end

    end

  end
end
