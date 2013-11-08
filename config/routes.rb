Danceparty911V2::Application.routes.draw do

  #devise_for :users
  devise_for :users do get '/users/sign_out' => 'devise/sessions#destroy' end
  root 'login#index'
  get 'new' => 'tracks#index'
  resources :tracks
  get 'welcome' => 'welcome#index'
  get 'dj' => 'dj#index'
  get 'temp' => 'temp#index'
  
end
