Rails.application.routes.draw do
  post '/addresses/create', to: 'addresses#create', as: 'create_address'
  resources :addresses
  get 'addresses/new', to: 'addresses#new', as: 'new_custom_address'
  get 'user_profile/index'
  get 'user_profile/orders'
  get 'user_profile/addresses'
  get 'user_profile/account'
  patch '/user_profile/update', to: 'user_profile#update', as: 'user_profile_update'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  devise_for :users
  root 'home#index'
  get 'shop' => 'home#shop'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
