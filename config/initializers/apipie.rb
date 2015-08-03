Apipie.configure do |config|
  config.app_name                 = "Medirectory"
  config.api_base_url             = "/api/v1"
  config.doc_base_url             = "/api"
  # set true/false for default validation
  config.validate                 = false
  # where is your API defined?
  config.api_controllers_matcher  = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.default_version          = "1.0"
  config.app_info                 = "A pilot project for a provider directory."
end
