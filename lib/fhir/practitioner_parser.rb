module Fhir
  module PractitionerParser
      LOOKUP_STRINGS = {
        given: :first_name,
        family: :last_name_legal_name
      }
      LOOKUP_TOKENS = {
        _id: :npi
      }
      T = Provider.arel_table

      def self.parse_matches_left(name, split_values)
        to_return = nil
        match_values = split_values.map {|value| value.to_s+"%"}
        case name
        when "name"
          to_return = T[:first_name].matches_any(match_values).or(
            T[:last_name_legal_name].matches_any(match_values)
            )
        else
          to_return = T[LOOKUP_STRINGS[name.intern]].matches_any(match_values) if LOOKUP_STRINGS[name.intern]
          to_return = T[LOOKUP_TOKENS[name.intern]].eq_any(split_values) if LOOKUP_TOKENS[name.intern]
        end
        to_return
      end

      def self.parse_matches(name, split_values)
        to_return = nil
        match_values = split_values.map {|value| "%"+value.to_s+"%"}
        case name
        when "name"
          to_return = T[:first_name].matches_any(match_values).or(
            T[:last_name_legal_name].matches_any(match_values)
            )
        else
          to_return = T[LOOKUP_STRINGS[name.intern]].matches_any(match_values) if LOOKUP_STRINGS[name.intern]
          to_return = T[LOOKUP_TOKENS[name.intern]].eq_any(split_values) if LOOKUP_TOKENS[name.intern]
        end
        to_return
      end

      def self.parse_exact(name, split_values)
        to_return = nil
        case name
        when "name"
          to_return = T[:first_name].eq_any(split_values).or(
            T[:last_name_legal_name].eq_any(split_values)
            )
        else
          to_return = T[LOOKUP_STRINGS[name.intern]].eq_any(split_values) if LOOKUP_STRINGS[name.intern]
          to_return = T[LOOKUP_TOKENS[name.intern]].eq_any(split_values) if LOOKUP_TOKENS[name.intern]
        end
        to_return
      end

      #  Should this be split to two separate functions? Should talk to Pete
      def self.parse_missing_modifier(name, missing)
        to_return = nil
        case name
        when "name"
          if missing
            to_return = T[:first_name].eq(nil).or(
              T[:last_name_legal_name].eq(nil)
            )
          else
            to_return = T[:first_name].not_eq(nil).or(
              T[:last_name_legal_name].not_eq(nil)
            )
          end
        else
          if missing
            to_return = T[LOOKUP_STRINGS[name.intern]].eq(nil) if LOOKUP_STRINGS[name.intern]
            to_return = T[LOOKUP_TOKENS[name.intern]].eq(nil) if LOOKUP_TOKENS[name.intern]
          else
            to_return = T[LOOKUP_STRINGS[name.intern]].not_eq(nil) if LOOKUP_STRINGS[name.intern]
            to_return = T[LOOKUP_TOKENS[name.intern]].not_eq(nil) if LOOKUP_TOKENS[name.intern]
          end

        end
        to_return
      end

  end
end
