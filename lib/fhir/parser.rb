module Fhir
  module Parser
    def self.parse_params_to_sql(params_string, fhir_resource_parser)
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
          queries << fhir_resource_parser.parse_exact(actual_name, split_values)
        elsif modifier == 'contains'
          # parse missing (true or false)
          queries << fhir_resource_parser.parse_matches(actual_name, split_values)
        elsif modifier == 'missing'
          # parse missing (true or false)
          missing = split_values.first == 'true'
          queries << fhir_resource_parser.parse_missing_modifier(actual_name, missing)
        else
          # Just use base. Only handling strings at the moments, so partials (%)
          queries << fhir_resource_parser.parse_matches_left(actual_name, split_values)
        end
      end if all_params
      queries
    end

  end
end
