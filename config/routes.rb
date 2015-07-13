Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :providers, only: [:index, :show]
      resources :organizations, only: [:index, :show]
      resources :taxonomies, only: :index
    end
  end

  namespace :fhir do
    resources :metadata, only: [:index]
    resources :practitioners, only: [:index, :show]
  end

end
