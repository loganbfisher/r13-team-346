Pugwarriors::Application.routes.draw do
  resources :authentications
  resources :games


  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users

  mount Foundation::Icons::Rails::Engine => '/fi'
  match '/users/signout' => 'sessions#destroy', :as => :signout
  match '/games/:id/join' => 'games#join'

  match '/auth/:provider/callback' => 'authentications#create'
end
