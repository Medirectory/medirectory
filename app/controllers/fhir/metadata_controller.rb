module Fhir
  class MetadataController < ApplicationController
    def index
      # Handles the _format case where the fhir user enters their format manually
      case params[:_format]
      when "json" 
        render "index.json"
      when "xml"
        render "index.xml"
      end 
    end
  end
end
