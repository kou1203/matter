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

  resources :summit_clients, only: [:index, :show] do
    collection { post :import }
  end

  resources :summits, expect: [:new, :create] do 
    collection { post :import }
    collection { post :import_price }
    collection { get :sw_error }
    collection { get :cancel }
  end

  resources :summit_customer_props do 
    collection { post :import}
  end 

  resources :summit_error_histories do 
    collection { post :import }
  end 

  resources :summit_billing_amounts do 
    collection { post :import }
  end 

  resources :summit_date_progresses, only: [:index]

  resources :summit_date_progresses, only: :show,param: :user_id


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

  resources :shifts,expect: [:show] do 
    collection do
      post :update_month
    end
  end 

  resources :shifts, only: :show,param: :user_id

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
      get :export
      get :date_progress
      get :ranking
      get :gross_profit
      get :profit
    }
  end  
  
  resources :ojts, only: :index do 
    collection { get :export }
    collection { get :index_export }
    collection { get :summary_export }
  end 
  resources :ojts, only: :show, param: :result_id



  resources :result_cashes do 
    collection { post :import}
  end
  resources :result_casas, expect: [:new, :create]
  resources :result_summits, expect: :show do 
    collection { get :base_profit }
  end 
  resources :result_summits, only: :show,param: :user_id
  
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
  resources :dmer_stocks
  resources :product_targets
  resources :demaekans, only: [:index] do 
    collection {post :import}
  end 

  resources :profits, only: [:index] do 
    collection {get :sum_export}
    collection {get :index_export}
    collection {get :profit_export_by_spreadsheet}
    collection {get :product_export_by_spreadsheet}
  end
  # get 'profits', to: 'profits#index' do 
  #   collection {get :sum_export}
  # end 

  resources :calc_periods do 
    collection {get :cash_csv_export}
    collection {get :cash_valuation_csv_export}
    collection {get :dmer_csv_export}
    collection {get :aupay_csv_export}
    collection {get :paypay_csv_export}
    collection {get :rakuten_pay_csv_export}
    collection {get :airpay_csv_export}
    collection {get :demaekan_csv_export}
    collection {get :austicker_csv_export}
    collection {get :dmersticker_csv_export}
  end 

  resources :dmer_date_progresses do 
    collection {get :progress_create}
    collection {get :csv_export}
    collection {get :date_destroy}
  end 
  
  resources :aupay_date_progresses do 
    collection {get :progress_create}
    collection {get :csv_export}
    collection {get :date_destroy}
  end 

  resources :paypay_date_progresses do 
    collection {get :progress_create}
    collection {get :date_destroy}
  end 

  resources :rakuten_pay_date_progresses do 
    collection {get :progress_create}
    collection {get :date_destroy}
  end 

  resources :airpay_date_progresses do 
    collection {get :progress_create}
    collection {get :date_destroy}
  end 

  resources :demaekan_date_progresses do 
    collection {get :progress_create}
    collection {get :date_destroy}
  end 
  resources :austicker_date_progresses do 
    collection {get :progress_create}
    collection {get :date_destroy}
  end 
  resources :dmersticker_date_progresses do 
    collection {get :progress_create}
    collection {get :date_destroy}
  end 
  resources :cash_date_progresses do 
    collection {get :progress_create}
    collection {get :date_destroy}
  end 

end
