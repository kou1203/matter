Rails.application.routes.draw do
  devise_for :users
  root to: 'results#index'
  resources :store_props do 
    collection { post :import }
    collection { get :export }
  end 

  resources :summit_clients, only: [:index, :show] do
    collection { post :import }
    collection { delete :all_delete }
  end

  resources :summits, expect: [:new, :create] do 
    collection { post :import }
    collection { post :import_price }
    collection { get :sw_error }
    collection { get :cancel }
    collection { delete :not_share_delete }
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

  resources :summit_date_progresses, only: [:index] do 
    collection {get :base}
  end 

  resources :summit_date_progresses, only: :show,param: :user_id


  resources :pranesses, expect: [:new, :create] do 
    collection { 
      post :import 
      get :simplified_chart
      get :not_payment
    }
  end 

  resources :payment_pranesses do 
    collection { 
      post :import 
      get :year_profit
      get :year_valuation
      get :not_payment
    }
  end 

  resources :praness_options do 
    collection {
      post :import 
    }
  end 

  resources :dmers do 
    collection { post :import }
    collection { get :index_export }
    collection { get :export }
    collection { get :simple_conf }
    collection { get :simple_conf_year }
    collection { get :deficiency }
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
    collection { 
      post :import 
      get :simple_conf 
    }
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
      delete :delete_month
    end
  end 

  resources :shifts, only: :show,param: :user_id

  resources :panda_profits, only: :index

  resources :results,expect: [:show]  do 
    get 'result_cashes/new'
    post 'result_cashes/create'
    get 'result_casas/new'
    get 'result_summits/new'
    post 'result_summits/create'
    collection { 
      post :import 
      get :export
      get :date_progress
      get :monthly_progress
      get :ranking
      get :gross_profit
      get :profit
      get :base_profit
      get :daily_report
      get :dup_index
      post :comment_new
      put :comment_update
      get :out_come
      get :base_productivity
      get :team_productivity
      get :person_productivity
      get :product_status
      get :slmt_list
      get :deficiency
      get :inc_or_dec
      get :valuation
    }
  end  

  resources :results, only: :show, param: :result_id
  get "date_fin/:id", to: "results#date_fin", as: "date_fin"
  get "weekly_fin/:id", to: "results#weekly_fin", as: "weekly_fin"
  get "out_val/:id", to: "results#out_val", as: "out_val"
  get "out_val_all/:id", to: "results#out_val_all", as: "out_val_all"
  get "time_val/:id", to: "results#time_val", as: "time_val"
  get "time_val_all/:id", to: "results#time_val_all", as: "time_val_all"
  get "store_val/:id", to: "results#store_val", as: "store_val"
  get "store_val_all/:id", to: "results#store_val_all", as: "store_val_all"

  get "monthly_get", to: "results#monthly_get", as: "monthly_get"
  get "monthly_get_base", to: "results#monthly_get_base", as: "monthly_get_base"
  get "sales_and_def", to: "results#sales_and_def", as: "sales_and_def"
  
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
    collection { get :person_data }
    collection { get :repeal_data }
    collection { get :sw_error_data }
    collection { get :error_history_data }
    collection { get :customer_prop_data }
    collection { get :billing_data }
    collection { get :prediction_data }
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
    collection { 
      post :import
      get :index_export 
      get :deficiency
      get :deficiency_new
      get :simple_conf
      get :simple_conf_year
    }
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
    collection {get :airpaysticker_csv_export}
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
  resources :airpaysticker_date_progresses do 
    collection {get :progress_create}
    collection {get :date_destroy}
  end 
  resources :cash_date_progresses do 
    collection {get :progress_create}
    collection {get :date_destroy}
  end 

  resources :itsses do 
    collection {post :import}
  end 

  resources :itss_date_progresses do 
    collection {get :progress_create}
    collection {get :date_destroy}
  end 

  resources :usen_pay_date_progresses do 
    collection {get :progress_create}
    collection {get :date_destroy}
  end 

  resources :airpay_stickers do 
    collection {post :import}
  end 

  resources :payment_cashes 
  resources :payment_dmers do 
    collection { 
      post :import
      get :not_payment
      get :conf_index
      get :result1
      get :result2
      get :result3
    }
  end 
  resources :payment_rakuten_pays do 
    collection { 
      post :import
      get :not_payment
      get :conf_index
      get :result
    }
  end 
  resources :payment_airpays do 
    collection { 
      post :import
      get :not_payment
      get :result
      get :conf_index
    }
  end 
  resources :payment_paypays do 
    collection { 
      post :import
      get :not_payment
      get :result
      get :conf_index
    }
  end 

  resources :payment_aupays do 
    collection { 
      post :import
      get :not_payment
      get :result
      get :conf_index
    }
  end 

  resources :payment_itsses do 
    collection { 
      post :import
      get :not_payment
      get :result
      get :conf_index
    }
  end 

  resources :spread_links do 
    collection {
      get :export
      get :base_export
    }
  end 

  resources :usen_pays do 
    collection {
      post :import
    }
  end 

  resources :valuation_results, only: [:index, :show] do 
    collection {
      get :product
    }
  end 

end
