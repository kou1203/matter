class CreatePaymentPaypays < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_paypays do |t|
      t.references :paypay, foreign_key: true
      t.string :controll_num
      t.string :store_name
      t.string :client
      t.string :company
      t.date :date
      t.date :result_point
      t.string :result_category
      t.integer :price
      t.date :payment, null: false
    end
  end
end
