Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :entities, only: :index
      resources :providers, only: :show
      resources :organizations, only: :show
    end
  end

end
