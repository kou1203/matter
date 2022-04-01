class CreateResultSales < ActiveRecord::Migration[6.1]
  def change
    create_table :result_sales do |t|
      t.references :user               , foreign_key: true 
      t.integer :year                  , null: false 
      t.integer :month                 , null: false 
      t.integer :valuation             , null: false
      t.integer :profit                , null: false
      t.string :product
    end
  end
end
