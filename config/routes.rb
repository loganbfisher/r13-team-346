Pugwarriors::Application.routes.draw do
  resources :authentications
  resources :games


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users

  match '/users/signout' => 'sessions#destroy', :as => :signout

  match '/auth/:provider/callback' => 'authentications#create'
end
