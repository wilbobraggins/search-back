Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do    
      resources :lookups
    end
  end

  root to: "home#index"
end
