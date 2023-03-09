class CreatePaymentRakutenPays < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_rakuten_pays do |t|
      t.references :rakuten_pay, foreign_key: true
      t.string :controll_num
      t.string :app_id
      t.string :store_name
      t.string :client
      t.string :company
      t.date :date
      t.date :result_point
      t.date :consent_form
      t.string :result_category
      t.integer :price
      t.date :payment, null: false
      
    end
  end
end
