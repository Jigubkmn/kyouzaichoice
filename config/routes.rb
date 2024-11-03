Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root 'top#index'
  get 'login', to: 'user_sessions#new'
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  post 'guest_login', to: 'user_sessions#guest_login'
  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider
  resources :users, only: %i[new create]
  resources :password_resets, only: %i[new create edit update]
  resource :profile_user, only: %i[show edit update]
  resources :qualifications, only: %i[new index create edit update destroy]
  resources :materials, only: %i[new index create edit update destroy] do
    collection { get :search } # 教材登録時の検索
    collection { get :index_autocomplete } # 教材一覧のオートコンプリート
    collection { get :already_registered } # 「追加済み教材」表示用
    collection { get :like } # 「いいねした教材」表示用
    resources :material_evaluations, only: %i[new create show]
    resources :likes, only: %i[create destroy], shallow: true
  end

  get 'term_of_service', to: "top#term_of_service"
  get 'privacy_policy', to: "top#privacy_policy"

end
