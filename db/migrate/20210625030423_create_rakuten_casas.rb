class CreateRakutenCasas < ActiveRecord::Migration[6.0]
  def change
    create_table :rakuten_casas do |t|
      t.string :client
      t.references :store_prop          ,foreign_key: true 
      t.references :user                ,foreign_key: true 
      t.date :date                      ,null: false 
      t.string :contract_type           ,null: false
      t.string :contracter              ,null: false
      t.string :line_type               ,null: false
      t.string :confirm_method          ,null: false
      t.string :hikari_collabo
      t.string :line_service            ,null: false 
      t.string :customer_num
      t.string :femto_id                 
      t.string :status                  
      t.string :error_status                  
      t.string :error_confirmer                  
      t.text :remarks                 
      t.date :payment
      t.integer :valuation_profit        ,null: false
      t.integer :actual_profit           ,null: false
    end
    add_index :rakuten_casas, [:customer_num], unique: true
  end
end
