class CreateAupays < ActiveRecord::Migration[6.0]
  def change
    create_table :aupays do |t|
      t.string :customer_num           
      t.string :client                   , null: false 
      t.references :user                 , foreign_key: true 
      t.references :store_prop           , foreign_key: true
      t.date :date                   , null: false 
      t.string :status                   , null: false 
      t.date :status_update
      t.references :settlementer
      t.date :settlement
      t.date :settlement_deadline
      t.string :status_settlement        ,null: false 
      t.date :status_update_settlement
      t.date :payment
      t.date :payment_settlement
      t.integer :profit_new             ,null: false
      t.integer :profit_settlement       ,null: false
      t.integer :valuation_new           ,null: false 
      t.integer :valuation_settlement    , null: false
      t.string :description
    end
    add_foreign_key :aupays, :users, column: :settlementer_id
    add_index :aupays, [:customer_num], unique: true
  end
end
