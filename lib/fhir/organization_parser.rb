module Fhir
  module OrganizationParser
    LOOKUP_NAMES = {
      _id: :npi,
      name: :organization_name_legal_business_name
    }
    T = Organization.arel_table

    def self.parse_matches(name, split_values)
      to_return = T[LOOKUP_NAMES[name.intern].intern].matches_any(split_values) if LOOKUP_NAMES[name.intern]
      to_return
    end

    def self.parse_exact(name, split_values)
      to_return = T[LOOKUP_NAMES[name.intern].intern].eq_any(split_values) if LOOKUP_NAMES[name.intern]
      to_return
    end

    #  Should this be split to two separate functions? Should talk to Pete
    def self.parse_missing_modifier(name, missing)
      if missing
        to_return = T[LOOKUP_NAMES[name.intern].intern].eq(nil) if LOOKUP_NAMES[name.intern]
      else
        to_return = T[LOOKUP_NAMES[name.intern].intern].not_eq(nil) if LOOKUP_NAMES[name.intern]
      end
      to_return
    end

  end
end
