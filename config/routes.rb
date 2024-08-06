Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'top#index'
  resources :users, only: %i[new create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resource :profile_user, only: %i[show edit update]
  resources :qualifications, only: %i[new index edit create update destroy]
  # Defines the root path route ("/")
  # root "articles#index"
end
