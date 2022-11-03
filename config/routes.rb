Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication
      post '/auth/sign_in', to: 'authentication#sign_in'
      get '/auth/verify', to: 'authentication#verify_email'
      get '/auth/request', to: 'authentication#request_email_token'

      # Admin
      get '/users/show', to: 'users#show_users'
      get '/users/show/:id', to: 'users#show_user'
      delete '/users/destroy/:id', to: 'users#destroy_user'

      # Patients
      post '/users/patient', to: 'users#create_patient'
      get '/users/patient/show', to: 'users#show_current_user'
      delete '/users/patient/destroy', to: 'users#destroy_current_user'
    end
  end
end
