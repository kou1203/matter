class CreatePaypays < ActiveRecord::Migration[6.0]
  def change
    create_table :paypays do |t|
      t.references :store_prop, foreign_key: true 
      t.references :user, foreign_key: true 
      t.string :client, null: false 
      t.date :get_date, null: false 
      t.string :status, null: false 
      t.date :payment
    end
  end
end
