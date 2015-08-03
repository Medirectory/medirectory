xml.soap(:Envelope, "xmlns:soap" => "http://www.w3.org/2003/05/soap-envelope", "xmlns:dsml" => "urn:oasis:names:tc:DSML:2:0:core") do
  xml.soap :Body do
    xml.dsml :batchResponse do
      xml.dsml :searchResponse do
        @providers.each do |provider|
          xml << render(:partial => 'hpd/soap/search_result_entry.soap.builder', locals: { provider: provider })
        end
        xml.dsml :searchResultDone do
          xml.dsml(:resultCode, code: 1)
        end
      end
    end
  end
end
