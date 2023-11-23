class CreateFixedSales < ActiveRecord::Migration[6.1]
  def change
    create_table :fixed_sales do |t|
      t.string :name           ,null: false 
      t.string :base           ,null: false
      t.date :date             ,null: false 
      t.integer :price         ,null: false

    end
  end
end
