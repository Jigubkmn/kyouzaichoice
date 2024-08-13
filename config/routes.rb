Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'top#index'
  resources :users, only: %i[new create]
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  resource :profile_user, only: %i[show edit update]
  resources :qualifications, only: %i[new index create edit update destroy]
  resources :materials, only: %i[new index create edit update destroy] do
    collection { get :search }#このルーティングを追加
    # material_evaluationコントローラーを用意していないため、material内に記述している
    resources :comments, only: %i[create edit destroy], shallow: true
  end
  # Defines the root path route ("/")
  # root "articles#index"
end
