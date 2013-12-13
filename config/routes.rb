Danceparty911V2::Application.routes.draw do

  #devise_for :users
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"} do get '/users/sign_out' => 'devise/sessions#destroy' end

  resources :members

  resources :tracks do
    collection do
      get 'remove_all/:id' => 'tracks#remove_all', as: 'remove_all'
      get 'play_thru'
      get 'click_pause'
      get 'dj_this_list/:id' => 'tracks#dj_this_list', as: 'dj_this_list'
      get 'single_list/:id' => 'tracks#single_list', as: 'single_list'
    end
  end

  root 'dj#index'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  get 'welcome' => 'welcome#index'
  get 'dj' => 'dj#index'
  get 'login' => 'login#index'

  match '/:username' => "dj#show", :via => :get
  match '/tracks/:username' => "tracks#show", :via => :get

end
