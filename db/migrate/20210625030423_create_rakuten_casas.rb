class CreateRakutenCasas < ActiveRecord::Migration[6.0]
  def change
    create_table :rakuten_casas do |t|
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
      t.string :net_contracter               ,null: false
      t.string :net_contracter_kana          ,null: false
      t.string :net_phone_number             ,null: false 
      # 不備
      t.string :error_status                 ,null: false                        
      t.date :error_solution                             
      # 設置
      t.references :putter                   
      t.string :status_put                   ,null: false
      t.date :status_update_put
      t.date :put
      t.date :put_deadline
      t.date :payment
      t.date :payment_put
      t.integer :profit_new                 ,null: false
      t.integer :profit_put                 ,null: false
      t.integer :valuation_new              ,null: false 
      t.integer :valuation_put              ,null: false
      t.text :description_error                 
      t.text :description                 
      t.string :vendor_material_code
      t.string :serial_number                 
      t.date :delivery_date
      t.string :inspection
      t.string :femto_id
    end
    add_foreign_key :rakuten_casas, :users, column: :putter_id
  end
end
