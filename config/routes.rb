Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      # Authentication
      post '/auth/sign_in', to: 'authentication#sign_in'
      get '/auth/verify', to: 'authentication#verify_email'
      get '/auth/request', to: 'authentication#request_email_token'

      # Users
      resources :users
      get '/user/show', to: 'users#show_current_user'
      put '/user/update', to: 'users#update_current_user'
      delete '/user/destroy', to: 'users#destroy_current_user'
      resources :patients, only: %i[index create]
      resources :doctors, only: %i[index create]

      # Transactions
      resources :transactions, only: [:create]
    end
  end
end
