Danceparty911V2::Application.routes.draw do

  devise_for :users
  root 'login#index'
  get 'new' => 'tracks#index'
  resources :tracks
  get 'welcome' => 'welcome#index'
  get 'dj' => 'dj#index'
  get 'temp' => 'temp#index'
  
end
