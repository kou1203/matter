Rails.application.routes.draw do
  devise_for :users
  root to: 'store_props#index'
  resources :store_props do 
    get 'pranesses/new'
    post 'pranesses/create'
    collection { post :import }
  end 
  resources :pranesses, expect: [:new, :create] do 
    collection { post :import }
  end 
  resources :dmers do 
    collection { post :import }
  end 
  resources :stocks do 
    collection { post :import }
    resources :stock_histories
    resources :return_histories
  end 
  
  resources :stock_histories, only: [:destroy]
  resources :return_histories, only: [:destroy]
  
end

# get 'stock_histories/new'
# post 'stock_histories/create'
# get 'return_histories/new'
# post 'return_histories/create'