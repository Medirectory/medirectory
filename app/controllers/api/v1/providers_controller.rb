module Api
  module V1

    class ProvidersController < ApplicationController
      SERIALIZATION_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
           {taxonomy_licenses: {include: :taxonomy_code}}, :taxonomy_groups ]
      LOAD_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
           {taxonomy_licenses: :taxonomy_code}, :taxonomy_groups ]

      def index
        providers = if params[:q]
                      Provider.basic_search(searchable_content: params[:q])
                    elsif params[:fuzzy_q]
                      Provider.fuzzy_search(searchable_content: params[:fuzzy_q])
                    else
                      Provider.all
                    end
        providers = providers.includes(LOAD_INCLUDES)
        providers = providers.offset(params[:offset]).limit(20)
        respond_to do |format|
          format.xml { render xml: providers, include: SERIALIZATION_INCLUDES }
          format.json { render json: MultiJson.encode(providers: providers.as_json(include: SERIALIZATION_INCLUDES)) }
        end
      end

      def show
        provider = Provider.find(params[:id])
        respond_to do |format|
          format.xml { render xml: provider, include: SERIALIZATION_INCLUDES }
          format.json { render json: MultiJson.encode(provider: provider.as_json(include: SERIALIZATION_INCLUDES)) }
        end
      end

    end

  end
end
