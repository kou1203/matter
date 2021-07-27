class CreatePaypays < ActiveRecord::Migration[6.0]
  def change
    create_table :paypays do |t|
      t.string :client                 , null: false 
      t.references :user               , foreign_key: true 
      t.references :store_prop         , foreign_key: true 
      t.date :date                     , null: false 
      t.string :status                 , null: false 
      t.date :status_update
      t.date :payment
      t.integer :profit             ,null: false
      t.integer :valuation          ,null: false
    end
  end
end
