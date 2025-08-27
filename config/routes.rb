Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Defines the root path route ("/")
  # root path...basic "homepage" with ability for an app to register itself...?

  # resources :users
  
  ## Session Routes
  get "login" => "sessions#login"
  post "create_session" => "sessions#create"
  post "sign_out" => "sessions#destroy"

  ## Oauth Routes
  get "authorize" => "oauth#authorize"
  get "consent" => "oauth#user_consent"
  post "oauth/token" => "oauth#token", as: :oauth_token
  get "introspect" => "oauth#introspect"
  post "oauth/revoke" => "oauth#revoke", as: :oauth_revoke

  get ".well-known/oauth-authorization-server" => "application#well_known_authorization_server", :as => :well_known_oauth_authorization_server
end
