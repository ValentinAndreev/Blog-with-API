Rails.application.routes.draw do
  root 'posts#index'

  resources :user_sessions
  resources :users
  resources :posts do
    resources :comments, only: [:create, :destroy]
  end

  get 'login' => 'user_sessions#new', as: :login
  delete 'logout' => 'user_sessions#destroy', as: :logout
end
