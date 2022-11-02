Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication
      get '/auth/verify', to: 'authentication#verify_email'
      post '/auth/login', to: 'authentication#login'

      # Users
      # Patient
      post 'users/patients', to: 'users#create_patient'

      # resources :users
    end
  end
end
