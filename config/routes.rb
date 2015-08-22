Rails.application.routes.draw do

  apipie
  namespace :api do
    namespace :v1 do
      resources :providers, only: [:index, :show]
      resources :organizations, only: [:index, :show]
      resources :taxonomies, only: :index
      resources :documentation, only: :index
    end
  end

  namespace :fhir do
    resources :metadata, only: [:index], defaults: { format: "xml" }
    resources :practitioners, only: [:index, :show], defaults: { format: "xml" }
    resources :organizations, only: [:index, :show], defaults: { format: "xml" }
  end

  namespace :hpd do
    get 'wsdl', to: 'soap#wsdl', defaults: { format: :wsdl }
    post 'endpoint', to: 'soap#endpoint', defaults: { format: :soap }
  end

end
