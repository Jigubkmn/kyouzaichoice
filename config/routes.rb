Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'top#index'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  post 'guest_login', to: 'user_sessions#guest_login'
  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
  resources :users, only: %i[new create]
  resource :profile_user, only: %i[show edit update]
  resources :qualifications, only: %i[new index create edit update destroy]
  resources :materials, only: %i[new index create edit update destroy] do
    collection { get :search } # 教材検索用
    collection { get :already_registered } # 「追加済み教材」表示用
    collection { get :like } # 「いいねした教材」表示用
    resources :material_evaluations, only: %i[new create show] do
      resources :comments, only: %i[create edit destroy], shallow: true
    end
    resources :likes, only: %i[create destroy], shallow: true
  end

  get 'term_of_service', to: "top#term_of_service"
  get 'privacy_policy', to: "top#privacy_policy"
  get 'inquiry', to: "top#inquiry"

end
