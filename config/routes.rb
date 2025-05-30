Rails.application.routes.draw do
  resource :sessions, only: %i[ create destroy ]
  get "sessions/status", to: "sessions#status"
  post "tokens/refresh", to: "tokens#refresh"
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # TODO: sign up
  # TODO: set up api versioning
  # TODO: match all controllers/models to a test file

  resources :books
  resources :authors
  resources :synopses
  resources :users
  # Defines the root path route ("/")
  # root "posts#index"
end
