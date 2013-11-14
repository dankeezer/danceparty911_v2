Danceparty911V2::Application.routes.draw do

  #devise_for :users
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"} do get '/users/sign_out' => 'devise/sessions#destroy' end

  resources :tracks

  root 'dj#index'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  get 'welcome' => 'welcome#index'
  get 'dj' => 'dj#index'
  get 'login' => 'login#index'

  # get 'new' => 'tracks#index'
  get ':username', to: 'dj#user'
end
