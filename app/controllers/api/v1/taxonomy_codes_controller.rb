module Api
  module V1

    class TaxonomyCodesController < ApplicationController

      def index
        codes = TaxonomyCode.all
        respond_to do |format|
          format.xml { render xml: codes}
          format.json { render json: codes}
        end
      end

      def show
        code = TaxonomyCode.find(params[:id])
        respond_to do |format|
          format.xml { render xml: code}
          format.json { render json: code}
        end
      end

    end

  end
end