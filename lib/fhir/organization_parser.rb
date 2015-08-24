module Fhir
  module OrganizationParser
    LOOKUP_STRINGS = {
      name: :organization_name_legal_business_name
    }
    LOOKUP_TOKENS = {
      _id: :npi
    }
    T = Organization.arel_table

    def self.parse_matches(name, split_values)
      case name
      when LOOKUP_TOKENS[name.intern]
        to_return = T[LOOKUP_TOKENS[name.intern].intern].eq_any(split_values) if LOOKUP_TOKENS[name.intern]
      else
        to_return = T[LOOKUP_STRINGS[name.intern].intern].matches_any(split_values) if LOOKUP_STRINGS[name.intern]
      end
      to_return
    end

    def self.parse_exact(name, split_values)
      case name
      when LOOKUP_TOKENS[name.intern]
        to_return = T[LOOKUP_TOKENS[name.intern].intern].eq_any(split_values) if LOOKUP_TOKENS[name.intern]
      else
        to_return = T[LOOKUP_STRINGS[name.intern].intern].eq_any(split_values) if LOOKUP_STRINGS[name.intern]
      end
      to_return
    end

    #  Should this be split to two separate functions? Should talk to Pete
    def self.parse_missing_modifier(name, missing)
      case name
      when LOOKUP_TOKENS[name.intern]
        if missing
          to_return = T[LOOKUP_TOKENS[name.intern].intern].eq(nil) if LOOKUP_TOKENS[name.intern]
        else
          to_return = T[LOOKUP_TOKENS[name.intern].intern].not_eq(nil) if LOOKUP_TOKENS[name.intern]
        end
      else
        if missing
          to_return = T[LOOKUP_STRINGS[name.intern].intern].eq(nil) if LOOKUP_STRINGS[name.intern]
        else
          to_return = T[LOOKUP_STRINGS[name.intern].intern].not_eq(nil) if LOOKUP_STRINGS[name.intern]
        end
      end
      to_return
    end

  end
end
