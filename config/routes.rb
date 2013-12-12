Danceparty911V2::Application.routes.draw do

  #devise_for :users
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks"} do get '/users/sign_out' => 'devise/sessions#destroy' end

  resources :members

  resources :tracks do
    collection do
      get 'remove_all'
      get 'play_thru'
      get 'click_pause'
    end
  end

  get 'dj_this_list' => 'tracks#dj_this_list'
  get 'single_list' => 'tracks#single_list'

  root 'dj#index'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  get 'welcome' => 'welcome#index'
  get 'dj' => 'dj#index'
  get 'login' => 'login#index'
  get 'old' => 'old_page#index'

  # get 'new' => 'tracks#index'
  get ':username', to: 'dj#user'

end
