Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'top#index'
  resources :users, only: %i[new create]
  # Defines the root path route ("/")
  # root "articles#index"
end
