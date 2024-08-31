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
    collection { get :search } # 教材検索用
    collection { get :already_registered } # 「追加済み教材」表示用
    collection { get :like } # 「いいねした教材」表示用
    resources :material_evaluations, only: %i[create show] do
      resources :comments, only: %i[create edit destroy], shallow: true
    end
  end
end
