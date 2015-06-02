module Api
  module V1

    class EntitiesController < ApplicationController

      def index
        # This doesn't yet do any deep searching, and is likely slow for lots of data; We may want to consider
        # just doing http://blog.lostpropertyhq.com/postgres-full-text-search-is-good-enough/

        # We also want to do pagination; that's a bit harder with two tables, and suggests we might want to go
        # back to a single table

        wildcard_query = "%#{params[:q]}%"
        entities = Provider.where("LOWER(last_name_legal_name) LIKE LOWER(:q)", q: wildcard_query)
        entities += Organization.where("LOWER(organization_name_legal_business_name) LIKE LOWER(:q)", q: wildcard_query)
        respond_to do |format|
          format.xml { render xml: entities }
          format.json { render json: entities }
        end
      end

    end

  end
end
