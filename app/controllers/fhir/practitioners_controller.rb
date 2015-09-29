require 'fhir/parser'
require 'fhir/practitioner_parser'
module Fhir
  class PractitionersController < ApplicationController
    LOAD_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
         {taxonomy_licenses: :taxonomy_code}, :taxonomy_groups, :organizations ]
    RESULTS_PER_PAGE = 8

    api :GET, 'fhir/practitioners', "Returns paginated results of a user-submitted search query. Will return all results (paginated) if no parameters specified."
    description "All parameters are optional.  This api is meant to follow the FHIR format, and there is a corresponding conformance endpoint decribing this implementaiton and it's capabilities."
    formats ['json', 'xml']
    example '
    {
      "resourceType": "Bundle",
      "type": "searchset",
      "total": [NUMBER],
      "link": [{
        "relation": "self",
        "url": "[LINK]"
      }, {
        "relation": "first",
        "url": "[LINK]"
      }, {
        "relation": "previous",
        "url": "[LINK]"
      }, {
        "relation": "next",
        "url": "[LINK]"
      }, {
        "relation": "last",
        "url": "[LINK]"
      }, {
        "relation": "base",
        "url": "[LINK]"
      }],
      "entry": [{
        "fullUrl": "[URL]",
        "resource": {
          "resourceType": "Practitioner",
          "identifier": [{
            "use": "[USE TYPE]",
            "label": "[ID TYPE]",
            "system": "[ID SYSTEM]",
            "value": "[ID VALUE]"
          }],
          "name": {
            "use": "[USE TYPE]",
            "text": "[NAME TO DISPLAY]",
            "family": ["LAST_NAME"],
            "given": ["[FIRST_NAME]", "[MIDDLE_NAME]"]
          },
          "telecom": [{
            "system": "[SYSTEM TYPE]",
            "value": "[ACCESS]",
            "use": "[USE TYPE]"
          }],
          "address": {
            "use": "[USE TYPE]",
            "text": "[FULL ADDRESS]",
            "line": ["[LINE1]", "[LINE2]", "..."],
            "city": "[CITY]",
            "state": "[STATE]",
            "zip": "[ZIP]",
            "country": "[COUNTRY]"
          },
          "gender": "[GENDER]",
          "organization": {
            "display": "[ORG NAME]"
          },
          "practitionerRole": [{
            "specialty": [{
              "coding": [{
                "code": "[SPECIALTY CODE/TOKEN]",
                "display": "[DISPLAY FOR SPECIALTY]"
              }]
            }]
          }]
        }
      }]
    }'
    param :_id,                   String,   :desc => "Search over unique id for practitioner."
    param :_format,               String,  :desc => "Defaults to xml.  Choice of xml or json."
    param :name,                  String,   :desc => "Specifies a search on the name of a practitioner. Matches any part of the first or last name."
    param "name:exact".intern,    String,   :desc => "Specifies a search on the name of a practitioner. Must match first or last name exactly (includes case)."
    param :given,                 String,   :desc => "Specifies a search on the first name of a practitioner. Matches any part of the first name."
    param "given:exact".intern,   String,   :desc => "Specifies a search on the first name of a practitioner. Must match first name exactly (includes case)."
    param :family,                String,   :desc => "Specifies a search on the last name of a practitioner. Matches any part of the last name."
    param "family:exact".intern,  String,   :desc => "Specifies a search on the last name of a practitioner. Must match last name exactly (includes case)."
    def index
      # a number of queries in FHIR run off the "matches any part of"
      #  Except is ':exact' is appended

      # Will need to custom parse params
      #  If the same param appears twice (name=blah&name=bleh) it's an AND operation
      #  If a param contains a comma though (name=blah,bleh) it's an OR operation
      #    (this is only true if the comma is not preceded by a \)
      queries = Fhir::Parser.parse_params_to_sql(request.original_url.split('?').second, Fhir::PractitionerParser)
      providers = Provider.all
      queries.each do |query|
        providers = providers.where(query) if query
      end

      providers = providers.order(:npi)
      @total = providers.size
      providers = providers.includes(LOAD_INCLUDES)
      providers = providers.offset(params[:offset]).limit(RESULTS_PER_PAGE)
      @providers = providers
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

    api :GET, 'fhir/practitioners/:id', "Returns a single organization record."
    description "Returns an organization for the provided id"
    formats ['json', 'xml']
    example '
    {
      "resourceType": "Practitioner",
      "identifier": [{
        "use": "[USE TYPE]",
        "label": "[ID TYPE]",
        "system": "[ID SYSTEM]",
        "value": "[ID VALUE]"
      }],
      "name": {
        "use": "[USE TYPE]",
        "text": "[NAME TO DISPLAY]",
        "family": ["LAST_NAME"],
        "given": ["[FIRST_NAME]", "[MIDDLE_NAME]"]
      },
      "telecom": [{
        "system": "[SYSTEM TYPE]",
        "value": "[ACCESS]",
        "use": "[USE TYPE]"
      }],
      "address": {
        "use": "[USE TYPE]",
        "text": "[FULL ADDRESS]",
        "line": ["[LINE1]", "[LINE2]", "..."],
        "city": "[CITY]",
        "state": "[STATE]",
        "zip": "[ZIP]",
        "country": "[COUNTRY]"
      },
      "gender": "[GENDER]",
      "organization": {
        "display": "[ORG NAME]"
      },
      "practitionerRole": [{
        "specialty": [{
          "coding": [{
            "code": "[SPECIALTY CODE/TOKEN]",
            "display": "[DISPLAY FOR SPECIALTY]"
          }]
        }]
      }]
    }'
    param :_format,               String,  :desc => "Defaults to xml.  Choice of xml or json."
    param :id,                    String,  :desc => "ID for the practitioner resource."
    def show
      @provider = Provider.includes(LOAD_INCLUDES).find(params[:id])
      case params[:_format]
      when "json"
        render "show.json"
      when "xml"
        render "show.xml"
      end
    end
  end
end
