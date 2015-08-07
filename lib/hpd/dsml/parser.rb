module Hpd
  module Dsml
    module Parser

      LOOKUP_TEXT = {
        givenName: "first_name",
        sn: "last_name_legal_name",
        # o: "organization_name_legal_business_name"
      }

      # TODO: handle undefined methods (i.e addRequest)
      def parse_batch(batch_request)
        requests = []
        batch_request.children.each do |request|
          requests.append({type: request.name, result: send(request.name.underscore, request)})
        end
        return requests
      end

      def search_request(request)
        filter = request.xpath("//dsml:filter", "dsml" => Hpd::Dsml::XMLNS)
        query = and_elem(filter.children)
        return query
      end

      def parse(element)
        case element.name
        when "equalityMatch"
          name = element.attr(:name)
          value = element.text.upcase
          {
            query: LOOKUP_TEXT[name.intern] + ' = :' + name,
            params: {name.intern => value}
          }
        when "and"
          and_elem(element.children)
        when "or"
          or_elem(element.children)
        else
          {
            query: "",
            params: {}
          }
        end
      end

      def and_elem(children)
        all_queries = []
        all_params = {}
        children.each do |child|
          # combine the seperate parsed children with and merge params
          values = parse(child)
          all_queries.push(values[:query])
          all_params = all_params.merge(values[:params])
        end
        {
          query: '(' + all_queries.join(' AND ') + ')',
          params: all_params
        }
      end

      def or_elem(children)
        all_queries = []
        all_params = {}
        children.each do |child|
          values = parse(child)
          all_queries.push(values[:query])
          all_params = all_params.merge(values[:params])
        end
        {
          query: '(' + all_queries.join(' OR ') + ')',
          params: all_params
        }
      end

    end
  end
end
