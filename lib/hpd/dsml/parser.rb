module Hpd
  module Dsml
    module Parser

      LOOKUP_TEXT = {
        givenName: "first_name",
        sn: "last_name_legal_name",
        HcPracticeLocation: "city", # just use city for now...
        Gender: 'gender_code',
        o: "organization_name_legal_business_name"
      }

      def self.parse_dn(dn_str)
        values = Hash.new
        array = dn_str.split(',')
        array.each do |e|
          value_pair = e.split('=')
          values[value_pair[0]] = value_pair[1]
        end
        return values
      end

      # TODO: handle undefined methods (i.e addRequest)
      def self.parse_batch(batch_request)
        requests = []
        batch_request.children.each do |request|
          requests.append({type: request.name, request_result: send(request.name.underscore, request)})
        end
        return requests
      end

      def self.search_request(request)
        # TODO: grab dn
        result = Hash.new
        filter = request.xpath("//dsml:filter", "dsml" => Hpd::Dsml::XMLNS)
        result[:search_type] = parse_dn(request.attribute("dn").value)["ou"]
        query = and_elem(filter.children)
        result.merge!(query)
        return result
      end

      def self.parse(element)
        case element.name
        when "equalityMatch"
          name = element.attr(:name)
          value = element.text.upcase
          {
            query: LOOKUP_TEXT[name.intern] + ' = ?',
            params: [value]
          }
        when "and"
          and_elem(element.children)
        when "or"
          or_elem(element.children)
        when "not"
          not_elem(element.children)
        else
          {
            query: "",
            params: []
          }
        end
      end

      def self.and_elem(children)
        all_queries = []
        all_params = []
        children.each do |child|
          # combine the seperate parsed children with and merge params
          values = parse(child)
          all_queries.push(values[:query])
          all_params = all_params + values[:params]
        end
        {
          query: '(' + all_queries.join(' AND ') + ')',
          params: all_params
        }
      end

      def self.or_elem(children)
        all_queries = []
        all_params = []
        children.each do |child|
          values = parse(child)
          all_queries.push(values[:query])
          all_params = all_params + values[:params]
        end
        {
          query: '(' + all_queries.join(' OR ') + ')',
          params: all_params
        }
      end

      def self.not_elem(children)
        all_queries = []
        all_params = []
        children.each do |child|
          values = parse(child)
          all_queries.push(values[:query])
          all_params = all_params + values[:params]
        end
        {
          query: 'NOT (' + all_queries.join(' AND ') + ')',
          params: all_params
        }
      end

    end
  end
end
