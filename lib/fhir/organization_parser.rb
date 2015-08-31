module Fhir
  module OrganizationParser
    LOOKUP_NAMES = {
      name: :organization_name_legal_business_name
    }
    LOOKUP_TOKENS = {
      _id: :npi
    }
    T = Organization.arel_table

    def self.parse_matches(name, split_values)
      match_values = split_values.map {|value| '%'+value.to_s+'%'}
      to_return = T[LOOKUP_TOKENS[name.intern]].eq_any(split_values) if LOOKUP_TOKENS[name.intern]
      to_return = T[LOOKUP_NAMES[name.intern]].matches_any(match_values) if LOOKUP_NAMES[name.intern]
      to_return
    end

    def self.parse_exact(name, split_values)
      to_return = T[LOOKUP_NAMES[name.intern]].eq_any(split_values) if LOOKUP_NAMES[name.intern]
      to_return = T[LOOKUP_TOKENS[name.intern]].eq_any(split_values) if LOOKUP_TOKENS[name.intern]
      to_return
    end

    #  Should this be split to two separate functions? Should talk to Pete
    def self.parse_missing_modifier(name, missing)
      if missing
        to_return = T[LOOKUP_NAMES[name.intern]].eq(nil) if LOOKUP_NAMES[name.intern]
        to_return = T[LOOKUP_TOKENS[name.intern]].eq(nil) if LOOKUP_TOKENS[name.intern]
      else
        to_return = T[LOOKUP_NAMES[name.intern]].not_eq(nil) if LOOKUP_NAMES[name.intern]
        to_return = T[LOOKUP_TOKENS[name.intern]].eq(nil) if LOOKUP_TOKENS[name.intern]
      end
      to_return
    end

  end
end
