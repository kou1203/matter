Rails.application.routes.draw do
  devise_for :users
  root to: 'results#index'
  resources :store_props do 
    get 'pranesses/index'
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
    get 'st_insurances/new'
    post 'st_insurances/create'
    get 'rakuten_pays/new'
    post 'rakuten_pays/create'
    collection { post :import }
    collection { get :export }
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

  resources :airpays do
    collection { post :import }
  end
  
  resources :stock_histories, only: [:destroy]
  resources :return_histories, only: [:destroy]
  
  resources :pandas, expect: [:new, :create] do 
    collection {post :import}
  end 

  resources :users do 
    collection {post :comment_new}
    collection {put :comment_update}
  end

  resources :shifts do 
    collection do
      post :update_month
    end
  end 

  resources :panda_profits, only: :index

  resources :results do 
    get 'result_cashes/new'
    post 'result_cashes/create'
    get 'result_casas/new'
    post 'result_casas/create'
    get 'result_summits/new'
    post 'result_summits/create'
    collection { 
      post :import 
      get :date_progress
    }
  end  

  resources :result_cashes do 
    collection { post :import}
  end
  resources :result_casas, expect: [:new, :create]
  resources :result_summits, expect: [:new, :create]
  
  resources :n_results do 
    collection { post :import }
  end  

  resources :products
  
  resources :display_periods
  
  resources :trouble_ns do 
    collection { post :import }
  end

  resources :rakuten_casas ,expect: [:new, :create] do 
    collection { post :import }
  end 

  resources :trouble_sses ,expect: [:new, :create] do 
    collection { post :import }
  end 

  resources :st_insurances ,expect: [:new, :create] do 
    collection { post :import }
  end 

  resources :rakuten_pays do 
    collection { post :import }
  end 

  resources :error_pages
  
  resources :costs 

  resources :product_checkers, only: [:index]
  resources :product_tests, only: [:index]
  
  resources :result_sales, only: [:index] do 
    collection { post :import }
  end 

  resources :comments

  resources :def_respondings, only: [:index]
  
  resources :settlements, only: [:index]
  resources :other_products
end
