module Fhir
  class PractitionersController < ApplicationController
    LOAD_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
         {taxonomy_licenses: :taxonomy_code}, :taxonomy_groups, :organizations ]
    RESULTS_PER_PAGE = 3

    LOOKUP_NAMES = {
      _id: :npi,
      given: :first_name,
      family: :last_name_legal_name
    }
    def parse_params_to_sql(t, params_string)
      all_params = params_string.split('&') if params_string
      # pack the seperate queries into a single array
      queries = []
      all_params.each do |param|
        split = param.split('=')
        actual_name = split.first.split(':').first
        modifier = split.first.split(':').second
        # Find all values to be "OR"ed, will need to do further work on composite
        #  or tokened values in the future
        split_values = split[1..split.length].join('=').split(/(?<!\\),/)
        if modifier == 'exact'
          # parse exact (no %)
          queries << parse_exact(t, actual_name, split_values)
        elsif modifier == 'missing'
          # parse missing (true or false)
          missing = split_values.first == 'true'
          parse_missing_modifier(t, actual_name, missing)
        else
          # Just use base. Only handling strings at the moments, so partials (%)
          split_values = split_values.map {|value| '%'+value.to_s+'%'}
          queries << parse_matches(t, actual_name, split_values)
        end
      end if all_params
      queries
    end

    def parse_matches(t, name, split_values)
      to_return = nil
      case name
      when "name"
        to_return = t[:first_name].matches_any(split_values).or(
          t[:last_name_legal_name].matches_any(split_values)
          )
      else
        to_return = t[LOOKUP_NAMES[name.intern].intern].matches_any(split_values) if LOOKUP_NAMES[name.intern]
      end
      to_return
    end

    def parse_exact(t, name, split_values)
      to_return = nil
      case name
      when "name"
        to_return = t[:first_name].eq_any(split_values).or(
          t[:last_name_legal_name].eq_any(split_values)
          )
      else
        to_return = t[LOOKUP_NAMES[name.intern].intern].eq_any(split_values) if LOOKUP_NAMES[name.intern]
      end
      to_return
    end

    #  Should this be split to two separate functions? Should talk to Pete
    def parse_missing_modifier(t, name, missing)
      to_return = nil
      case name
      when "name"
        if missing
          to_return = t[:first_name].eq(nil).or(
            t[:last_name_legal_name].eq(nil)
          )
        else
          to_return = t[:first_name].not_eq(nil).or(
            t[:last_name_legal_name].not_eq(nil)
          )
        end
      else
        if missing
          to_return = t[LOOKUP_NAMES[name.intern].intern].eq(nil) if LOOKUP_NAMES[name.intern]
        else
          to_return = t[LOOKUP_NAMES[name.intern].intern].not_eq(nil) if LOOKUP_NAMES[name.intern]
        end

      end
      to_return
    end

    def index
      # a number of queries in FHIR run off the "matches any part of"
      #  Except is ':exact' is appended
      t = Provider.arel_table

      # Will need to custom parse params
      #  If the same param appears twice (name=blah&name=bleh) it's an AND operation
      #  If a param contains a comma though (name=blah,bleh) it's an OR operation
      #    (this is only true if the comma is not preceded by a \)
      queries = parse_params_to_sql(t, request.original_url.split('?').second)
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
      @link_to[:last] = if @total > RESULTS_PER_PAGE
        @params[:offset] = (@total-@total%RESULTS_PER_PAGE).to_s
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
