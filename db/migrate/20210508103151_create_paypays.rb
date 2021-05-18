class CreatePaypays < ActiveRecord::Migration[6.0]
  def change
    create_table :paypays do |t|
      t.string :client                 , null: false 
      t.references :user               , foreign_key: true 
      t.references :store_prop         , foreign_key: true 
      t.date :get_date                 , null: false 
      t.date :payment
      t.string :status                 , null: false 
      t.string :before_status
    end
  end
end
