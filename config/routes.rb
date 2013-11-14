Danceparty911V2::Application.routes.draw do

  #devise_for :users
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"} do get '/users/sign_out' => 'devise/sessions#destroy' end

  resources :tracks

  root 'old_page#index'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  namespace :user do
    root :to => "dj#index"
  end

  get 'welcome' => 'welcome#index'
  get 'beta' => 'dj#index'
  get 'login' => 'login#index'

  # get 'new' => 'tracks#index'
  get ':username', to: 'dj#user'
end
