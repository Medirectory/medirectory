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
  end

  resources :hpd, only:[] do
      get 'wsdl', defaults: { format: :wsdl }, on: :collection
      post 'endpoint', defaults: { format: :soap }, on: :collection
  end

end
