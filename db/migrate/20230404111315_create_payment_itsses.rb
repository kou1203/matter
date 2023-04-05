class CreatePaymentItsses < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_itsses do |t|
      t.references :itss, foreign_key: true
      t.string :entry_date
      t.string :controll_num
      t.string :p_num
      t.string :customer_name
      t.integer :price
      t.string :company
      t.string :client
      t.date :payment, null: false
    end
  end
end
