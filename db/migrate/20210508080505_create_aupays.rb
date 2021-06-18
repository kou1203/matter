class CreateAupays < ActiveRecord::Migration[6.0]
  def change
    create_table :aupays do |t|
      t.string :customer_num             ,null: false 
      t.string :client                   , null: false 
      t.references :user                 , foreign_key: true 
      t.references :store_prop           , foreign_key: true
      t.date :get_date                   , null: false 
      t.date :payment
      t.string :status                   , null: false 
      t.string :before_status
      t.date :settlement
      t.string :description
      t.integer :valuation_profit     ,null: false
      t.integer :actual_profit        ,null: false
    end
    add_index :aupays, [:customer_num], unique: true
  end
end
