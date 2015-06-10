module Api
  module V1

    class TaxonomyCodesController < ApplicationController

      def index
        codes = if params[:code]
                  TaxonomyCode.where(code: params[:code])
                else
                  TaxonomyCode.all
                end
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