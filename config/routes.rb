Rails.application.routes.draw do
  root 'posts#index'

  namespace :api do
    namespace :v1 do
      get 'posts', to: 'posts#index'
      get 'posts/:post_id', to: 'posts#show'
      post 'posts', to: 'posts#create'
      post 'authenticate', to: 'sessions#create'
    end
  end

  resources :user_sessions
  resources :users
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  get 'login' => 'user_sessions#new', as: :login
  delete 'logout' => 'user_sessions#destroy', as: :logout
end
