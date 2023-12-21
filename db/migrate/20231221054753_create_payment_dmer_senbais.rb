class CreatePaymentDmerSenbais < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_dmer_senbais do |t|
      t.references :dmer_senbai, foreign_key: true
      t.string :client, nill: false 
      t.string :store_code, null: false 
      t.string :customer_num
      t.string :store_name
      t.date :date 
      t.date :payment ,null: false
      t.integer :price,null: false
    end
  end
end
