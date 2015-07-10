module Api
  module V1
    module Fhir
      class MetadataController < ApplicationController
        def index
          render "api/v1/fhir/conformance/index.xml"
        end
      end
    end
  end
end

