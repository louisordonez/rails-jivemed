Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      post '/auth/sign_in', to: 'authentication#sign_in'
    end
  end
end
