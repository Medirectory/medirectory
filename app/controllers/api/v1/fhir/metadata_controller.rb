module Api
  module V1
    module Fhir
      class MetadataController < ApplicationController
        def index
          respond_to do |format|
            format.xml { render "api/v1/fhir/conformance/index.xml" }
            format.json { render "api/v1/fhir/conformance/index.json" }
          end
        end
      end
    end
  end
end

