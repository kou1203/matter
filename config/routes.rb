Rails.application.routes.draw do
  devise_for :users
  root to: 'store_props#index'
  resources :store_props do 
    get 'pranesses/new'
    post 'pranesses/create'
    get 'summits/new'
    post 'summits/create'
    get 'dmers/new'
    post 'dmers/create'
    get 'aupays/new'
    post 'aupays/create'
    get 'paypays/new'
    post 'paypays/create'
    get 'pandas/new'
    post 'pandas/create'
    collection { post :import }
  end 
  resources :summits, expect: [:new, :create] 
  resources :pranesses, expect: [:new, :create] do 
    collection { post :import }
  end 
  resources :dmers, expect: [:new, :create] do 
    collection { post :import }
  end 
  resources :stocks do 
    collection { post :import }
    resources :stock_histories
    resources :return_histories
  end 

  resources :aupays, expect: [:new, :create] do 
    collection { post :import }
  end 

  resources :paypays, expect: [:new, :create] do 
    collection { post :import }
  end 
  
  resources :stock_histories, only: [:destroy]
  resources :return_histories, only: [:destroy]
  
  resources :pandas, expect: [:new, :create] do 
    collection { post :import }
  end 

end

# get 'stock_histories/new'
# post 'stock_histories/create'
# get 'return_histories/new'
# post 'return_histories/create'