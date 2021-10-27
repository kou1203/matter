class CreateRakutenCasas < ActiveRecord::Migration[6.0]
  def change
    create_table :rakuten_casas do |t|
      # 新規
      t.string :client                       ,null: false 
      t.references :user                     ,foreign_key: true 
      t.references :store_prop               ,foreign_key: true 
      t.date :date                           ,null: false 
      t.string :status                       ,null: false
      t.date :status_update
      t.string :net_confirm_method           ,null: false
      t.string :net_name                     ,null: false
      t.string :hikari_collabo               ,null: false
      t.string :net_plan                     ,null: false 
      t.string :customer_num                 ,null: false 
      t.string :net_address                  ,null: false 
      t.string :net_contracter               ,null: false
      t.string :net_contracter_kana          ,null: false
      t.string :net_phone_number             ,null: false 
      t.text :remarks
      t.date :share
      # 自社不備
      t.date :deficiency                             
      t.string :status_deficiency          
      t.date :deficiency_solution        
      t.text :deficiency_remarks                  
      # 回線不備
      t.date :deficiency_net                             
      t.string :status_deficiency_net          
      t.date :deficiency_share_net                             
      t.date :deficiency_last_shared_net                             
      t.text :deficiency_result_net                  
      t.text :deficiency_remarks_net                  
      t.date :deficiency_solution_net        
      # 反社不備
      t.date :deficiency_anti
      t.string :status_deficiency_anti
      t.date :deficiency_share_anti
      t.date :deficiency_last_shared_anti
      t.text :deficiency_result_anti
      t.text :deficiency_remarks_anti
      t.date :deficiency_solution_anti
      # 端末情報
      t.date :order
      t.date :arrival
      t.string :femto_id
      t.string :inspection
      t.date :done_oss # 第一成果地点
      # 設置
      t.date :put_plan
      t.date :put
      t.references :putter                   
      t.string :radio_waves              
      t.date :google_form_share
      t.string :status_put
      # 図書
      t.date :share_book
      t.string :status_book
      t.date :deficiency_book
      t.text :deficiency_remarks_book
      t.text :deficiency_result_book
      t.date :deficiency_solution_book
      t.date :done_book #第二成果地点
      # 未完図書
      t.date :share_undone_book
      t.string :status_undone_book
      t.date :deficiency_solution_undone_book
      t.date :done_undone_book #第二成果地点
      # システム調整
      t.string :radio_waves_undone
      t.date :put_adjustment
      t.references :adjustmenter
      t.date :share_adjustment
      t.date :deficiency_adjustment
      t.date :deficiency_solution_adjustment
      t.date :google_form_share_adjustment
      t.string :adjustment_status
      t.date :done_adjustment #第三成果地点
      # 申込書
      t.date :share_app
      t.date :app_create 
      t.string :status_app
      t.date :done_app
      # 覚書
      t.date :share_memo
      t.date :memo_create
      t.string :status_memo
      t.date :done_memo
      t.string :letter_pack_num1
      t.string :letter_pack_num2
      # 成果地点、入金
      t.date :payment
      t.date :payment_put
      t.integer :profit_new                 ,null: false
      t.integer :profit_put                 ,null: false
      t.integer :valuation_new              ,null: false 
      t.integer :valuation_put              ,null: false
    end
    add_foreign_key :rakuten_casas, :users, column: :putter_id
    add_foreign_key :rakuten_casas, :users, column: :adjustmenter_id
  end
end
