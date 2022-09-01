class CreateProductTargets < ActiveRecord::Migration[6.1]
  def change
    create_table :product_targets do |t|
      t.date :date, null: false 
      t.string :product, null: false 
      t.string :base, null: false 
      t.integer :product_len, null: false 
      t.integer :product_valuations
    end
  end
end
