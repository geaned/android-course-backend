Rails.application.routes.draw do
  get '/users/get-profile', to: 'users#show_self'
  resources :posts, :users

  post '/registration/create-profile', to: 'registration#create'
  post '/auth/sign-in-with-email', to: 'auth#login_with_email'
  post '/auth/refresh-tokens', to: 'auth#check_refresh_token'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
