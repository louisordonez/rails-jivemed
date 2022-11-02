Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication
      get '/auth/request', to: 'authentication#request_email_token'
      get '/auth/verify', to: 'authentication#verify_email'
      post '/auth/sign_in', to: 'authentication#sign_in'

      # Users - Admin
      get '/users/show/:id', to: 'users#show_user'

      # Users - Patients
      post '/users/patients', to: 'users#create_patient'
    end
  end
end
