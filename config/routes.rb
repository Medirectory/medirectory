Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :providers, only: [:index, :show]
      resources :organizations, only: [:index, :show]
      resources :taxonomy_codes, only: [:index, :show]
    end
  end

end
