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
    get 'summit_customer_props/new'
    post 'summit_customer_props/create'
    get 'rakuten_casas/new'
    post 'rakuten_casas/create'
    get 'trouble_sses/new'
    post 'trouble_sses/create'
    collection { post :import }
  end 

  resources :summit_customer_props, expect: [:new, :create] do
    get 'summits/new'
    post 'summits/create'
    collection { post :import }
  end

  resources :summits, expect: [:new, :create] do 
    collection { post :import }
  end


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

  resources :users

  resources :shifts

  resources :panda_profits, only: :index

  resources :results do 
    collection { post :import }
  end  
  
  resources :n_results do 
    collection { post :import }
  end  

  resources :products
  
  resources :trouble_ns do 
    collection { post :import }
  end

  resources :rakuten_casas ,expect: [:new, :create] do 
    collection { post :import }
  end 

  resources :trouble_sses ,expect: [:new, :create] do 
    collection { post :import }
  end 

  resources :costs 

  resources :actual_profits

end
