module Api
  module V1

    class ProvidersController < ApplicationController

      def show
        provider = Provider.find(params[:id])
        respond_to do |format|
          format.xml { render xml: provider }
          format.json { render json: provider }
        end
      end

    end

  end
end
