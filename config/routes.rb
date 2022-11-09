Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication
      post '/auth/sign_in', to: 'authentication#sign_in'
      get '/auth/verify', to: 'authentication#verify_email'
      get '/auth/request', to: 'authentication#request_email_token'

      # Users
      get '/users/show', to: 'users#users'
      get '/users/patients', to: 'users#patients'
      get '/users/doctors', to: 'users#doctors'

      get '/users/show/:id', to: 'users#user'
      post '/users/patient', to: 'users#create_patient'
      patch '/users/update/:id', to: 'users#update_user'
      delete '/users/destroy/:id', to: 'users#destroy_user'

      get '/users/patient/show', to: 'users#current_user'
      patch '/users/patient/update', to: 'users#update_current_user'
      delete '/users/patient/destroy', to: 'users#destroy_current_user'

      # Payment
      post :reservations, to: 'reservations#create'
    end
  end
end
