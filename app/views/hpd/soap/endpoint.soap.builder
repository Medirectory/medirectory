xml.soap(:Envelope, "xmlns:soap" => "http://www.w3.org/2003/05/soap-envelope", "xmlns:dsml" => "urn:oasis:names:tc:DSML:2:0:core") do
  xml.soap :Body do
    xml.dsml :BatchResponse do
      xml.dsml :SearchResponse do
        @providers.each do |provider|
          xml.dsml << render(:partial => 'hpd/soap/search_result_entry.soap.builder', locals: { provider: provider })
        end
      end
    end
  end
end
