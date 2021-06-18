class CreateSummitCustomerProps < ActiveRecord::Migration[6.0]
  def change
    create_table :summit_customer_props do |t|
      t.string :customer_num           , null: false 
      t.string :client                  , null: false 
      t.references :store_prop          , foreign_key: true 
      t.string :claim_house             , null: false 
      t.string :claim_address           , null: false 
      t.string :contract_name           , null: false 
      t.string :before_electric
    end
    add_index :summit_customer_props, [:customer_num], unique: true 
  end
end
