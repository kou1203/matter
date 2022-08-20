class CreateOtherProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :other_products do |t|
      t.references :user                , foreign_key: true
      t.string :product_name            ,null: false 
      t.date :date
      t.integer :product_len
      t.integer :profit                 ,null: false 
      t.integer :valuation              ,null: false 
    end
  end
end
