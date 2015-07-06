Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :providers, only: [:index, :show]
      resources :organizations, only: [:index, :show]
      resources :taxonomies, only: :index
      resources :fhir_practitioners, only: [:index, :show]
    end
  end

end
