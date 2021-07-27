class CreateRakutenCasas < ActiveRecord::Migration[6.0]
  def change
    create_table :rakuten_casas do |t|
      t.string :femto_id                 
      t.string :client
      t.references :user                ,foreign_key: true 
      t.references :store_prop          ,foreign_key: true 
      t.date :date                      ,null: false 
      t.string :status                  ,null: false
      t.date :status_update
      t.string :confirm_method          ,null: false
      t.string :net_name                ,null: false
      t.string :hikari_collabo          ,null: false
      t.string :net_plan                ,null: false 
      t.string :customer_num            ,null: false 
      t.string :net_contracter          ,null: false
      t.string :error_status            ,null: false                        
      t.date :error_solution                                    
      t.date :payment
      t.date :payment_put
      t.integer :profit_new           ,null: false
      t.integer :profit_put           ,null: false
      t.integer :valuation_new        ,null: false 
      t.integer :valuation_put        , null: false
      t.text :description_error                 
      t.text :description                 
    end
    add_index :rakuten_casas, [:femto_id], unique: true
  end
end
