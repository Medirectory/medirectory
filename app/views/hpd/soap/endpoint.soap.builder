xml.soap(:Envelope, "xmlns:soap" => "http://www.w3.org/2003/05/soap-envelope", "xmlns:dsml" => "urn:oasis:names:tc:DSML:2:0:core") do
  xml.soap :Body do
    xml.dsml :batchResponse do
      @results.each do |result|
        case result[:type]
        when 'searchRequest'
          xml.dsml :searchResponse do
            result[:providers].each do |provider|
              xml << render(:partial => 'hpd/soap/provider_search_result_entry.soap.builder', locals: { provider: provider })
            end
            xml.dsml :searchResultDone do
              xml.dsml(:resultCode, code: 1)
            end
          end
        end
      end
    end
  end
end
