Rails.application.routes.draw do
  devise_for :users
  root to: 'store_props#index'
  resources :store_props do 
    collection { post :import }
  end 
end
