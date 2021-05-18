class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string :stock_num      , null: false 
      t.string :mac_num        , null: false 
      t.string :status
      t.string :mail           ,null: false 
      t.text :remarks
    end
    add_index :stocks          , [:stock_num, :mac_num], unique: true
  end
end