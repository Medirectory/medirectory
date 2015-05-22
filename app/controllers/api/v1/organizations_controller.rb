module Api
  module V1

    class OrganizationsController < ApplicationController

      def show
        organization = Organization.find(params[:id])
        respond_to do |format|
          format.xml { render xml: organization }
          format.json { render json: organization }
        end
      end

    end

  end
end
