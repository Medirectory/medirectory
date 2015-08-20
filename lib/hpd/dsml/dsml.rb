module Hpd
  module Dsml
    XMLNS = "urn:oasis:names:tc:DSML:2:0:core"

    def validate(dsml_message)
      schema = Nokogiri::XML::Schema(File.read("#{Rails.root}/public/schema/DSML/DSMLv2.xsd"))
      errors = schema.validate(dsml_message).map{|e| e.message}.join(", ")
      raise(StandardError, errors) unless errors.empty?
    end
  end
end
