Rails.application.routes.draw do

  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :author
      resources :tag
      resources :post do
        resources :comment
      end
    end
  end

end
