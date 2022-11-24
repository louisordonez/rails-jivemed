Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication
      post '/auth/sign_in', to: 'authentication#sign_in'
      get '/auth/verify', to: 'authentication#verify_email'
      get '/auth/request', to: 'authentication#request_email_token'

      # Users
      resources :users, only: %i[index show destroy]
      get '/user/show', to: 'users#show_current_user'
      put '/user/update', to: 'users#update_current_user'
      delete '/user/destroy', to: 'users#destroy_current_user'
      resources :patients, only: %i[index create update]
      resources :doctors, only: %i[index create update]

      # Destroyed
      get '/destroyed/users', to: 'users#destroyed'

      # Departments
      resources :departments

      # Schedules
      resources :schedules

      # Appointments
      resources :appointments, only: %i[index show create]

      # User Transactions
      resources :user_transactions, only: %i[index show]
    end
  end
end
