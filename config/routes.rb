Danceparty911V2::Application.routes.draw do

  root 'tracks#index'
  get 'new' => 'tracks#index'
  resources :tracks
  get 'welcome' => 'welcome#index'
  get 'dj' => 'dj#index'
  get 'temp' => 'temp#index'
  
end
