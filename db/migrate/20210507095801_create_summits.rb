class CreateSummits < ActiveRecord::Migration[6.0]
  def change
    create_table :summits do |t|
      t.string :customer_num
      t.string :client
      t.references :user                , foreign_key: true 
      t.references :store_prop          , foreign_key: true 
      t.date :get_date                  , null:false 
      t.date :payment
      t.string :status                  , null: false 
      t.string :before_status
      t.string :claim_house             , null: false 
      t.string :claim_address           , null: false 
      t.string :before_electric
      t.string :supply_num
      t.string :pay_as
      t.string :weight
      t.string :menu                   , null:false 
      t.date :start                    , null: false 
      t.integer :fee
      t.string :remarks
    end
    add_index :summits, [:customer_num], unique: true 
  end
end
