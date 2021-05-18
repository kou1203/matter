class CreateDmers < ActiveRecord::Migration[6.0]
  def change
    create_table :dmers do |t|
      t.string :customer_num       , null: false 
      t.string :client
      t.references :user           , foreign_key: true
      t.references :store_prop     , foreign_key: true
      t.date :get_date             , null:false 
      t.date :payment
      t.string :status             , null: false 
      t.string :before_status
      t.text :description
      t.date :settlement_payment
      t.date :picture_payment
    end
    add_index :dmers, [:customer_num], unique: true 
  end
end