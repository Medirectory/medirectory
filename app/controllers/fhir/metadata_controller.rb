module Fhir
  class MetadataController < ApplicationController
    def index
      # Handles the _format case where the fhir user enters their format manually
      case params[:_format]
      when "json" 
        render "fhir/conformance/index.json"
      when "xml"
        render "fhir/conformance/index.xml"
      end 

      respond_to do |format|
        format.xml { render "fhir/conformance/index.xml" }
        format.json { render "fhir/conformance/index.json" }
      end unless params[:_format]
    end
  end
end
