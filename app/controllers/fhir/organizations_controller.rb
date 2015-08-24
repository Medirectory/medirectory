require 'fhir/parser'
require 'fhir/organization_parser'
module Fhir
  class OrganizationsController < ApplicationController
    LOAD_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
         {taxonomy_licenses: :taxonomy_code}, :taxonomy_groups, :providers ]
    RESULTS_PER_PAGE = 3

    def index
      # a number of queries in FHIR run off the "matches any part of"
      #  Except is ':exact' is appended

      # Will need to custom parse params
      #  If the same param appears twice (name=blah&name=bleh) it's an AND operation
      #  If a param contains a comma though (name=blah,bleh) it's an OR operation
      #    (this is only true if the comma is not preceded by a \)
      queries = Fhir::Parser.parse_params_to_sql(request.original_url.split('?').second, Fhir::OrganizationParser)
      organizations = Organization.all
      queries.each do |query|
        organizations = organizations.where(query) if query
      end

      organizations = organizations.order(:npi)
      @total = organizations.size
      organizations = organizations.includes(LOAD_INCLUDES)
      organizations = organizations.offset(params[:offset]).limit(RESULTS_PER_PAGE)
      @organizations = organizations
      @params = request.query_parameters
      original_offset = @params[:offset]
      offset = params[:offset].to_i || 0
      @link_to = {
        self: request.original_url,
        fhir_base: request.protocol + request.host_with_port + "/fhir",
        base: request.protocol + request.host_with_port + "/"
      }
      @link_to[:previous] = if (offset-RESULTS_PER_PAGE) >= 0
        @params[:offset] = (offset-RESULTS_PER_PAGE).to_s
        request.original_url.split('?').first + "?" + @params.to_query
      end
      @link_to[:next] = if (offset+RESULTS_PER_PAGE) < @total
        @params[:offset] = (offset+RESULTS_PER_PAGE).to_s
        request.original_url.split('?').first + "?" + @params.to_query
      end
      final_page = if @total%RESULTS_PER_PAGE == 0 then RESULTS_PER_PAGE else @total%RESULTS_PER_PAGE end
      @link_to[:last] = if @total > RESULTS_PER_PAGE
        @params[:offset] = (@total-final_page).to_s
        request.original_url.split('?').first + "?" + @params.to_query
      end
      @link_to[:first] = request.original_url.split('?').first
      @link_to[:first] = @link_to[:first] + "?" + @params.except(:offset).to_query unless @params.except(:offset).empty?

      # Handles the _format case where the fhir user enters their format manually
      case @params[:_format]
      when "json"
        render "index.json"
      when "xml"
        render "index.xml"
      end
    end

    def show
      @organization = Organization.includes(LOAD_INCLUDES).find(params[:id])
      case params[:_format]
      when "json"
        render "show.json"
      when "xml"
        render "show.xml"
      end
    end
  end
end
