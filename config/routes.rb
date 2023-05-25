Rails.application.routes.draw do
  delete '/remove_coupon', to: 'checkout#remove_coupon', as: 'remove_coupon'
  post '/checkout/apply_coupon', to: 'checkout#apply_coupon', as: 'apply_coupon'
  resources :orders do
    member do
      patch :return
    end
  end
  get 'codsuccess/show'
  resources :product
  get '/chart', to: 'chart#show'
  get '/payments/success', to: 'payments#success'
  post 'payments/create'
  get '/payments/callback' => 'payments#callback'
  get 'payments/new'

  get 'carts/show'
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

  resource :cart, only: [:show] do 
    member do
      put "add/:product_id", to: 'carts#add', as: :add_to
      put "remove/:product_id", to: 'carts#remove', as: :remove_from
      put "remove_one/:product_id", to: 'carts#removeone', as: :remove_one
    end
  end
  get '/carts/add/:product_id', to: 'carts#add', as: 'add_to_cart_custom'
  put '/carts/add/:product_id', to: 'carts#add'
  get '/checkout', to: 'checkout#checkout'
  post '/purchase', to: 'checkout#purchase'
  resources :orders
  get '/orders/history', to: 'orders#history', as: 'orders_history'

  resources :orders do
    member do
      get :order_confirmation
      patch :cancel
    end
  end

  resources :orders do
    member do
      get :order_confirmation
      delete :cancel
    end
  end
  

  resources :order_items
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'



  
  






  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
