class CreatePaymentDmers < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_dmers do |t|
      t.references :dmer, foreign_key: true
      t.string :controll_num
      t.string :customer_num
      t.string :store_code
      t.string :store_name
      t.string :client
      t.string :company
      t.date :date
      t.date :result_point
      t.date :settlement
      t.date :picture_done
      t.string :settlement_second
      t.string :result_category
      t.integer :price
      t.date :payment, null: false
      
    end
  end
end
