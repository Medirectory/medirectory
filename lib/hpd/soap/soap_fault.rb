module Hpd
  module Soap
    module SoapFault
      class ClientError < StandardError
        def fault_code
          "Client"
        end
      end
    end
  end
end

