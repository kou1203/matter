class CreatePaymentAupays < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_aupays do |t|
      t.references :aupay, foreign_key: true
      t.string :record_num
      t.string :store_name
      t.string :client
      t.string :company
      t.date :result_point
      t.string :result_category
      t.integer :price
      t.date :payment, null: false
    end
  end
end
