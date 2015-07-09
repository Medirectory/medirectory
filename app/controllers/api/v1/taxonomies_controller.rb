module Api
  module V1

    class TaxonomiesController < ApplicationController

      def index
        # NOTE: We'll need to figure out what's most useful on the front end, this will do for now
        #taxonomies = TaxonomyCode.all.map { |t| "#{t.classification}#{" (#{t.specialization})" if t.specialization}" }
        taxonomies = TaxonomyCode.all.map(&:classification)
        respond_to do |format|
          format.xml { render xml: taxonomies }
          format.json { render json: MultiJson.encode(taxonomies: taxonomies) }
        end
      end

    end

  end
end
