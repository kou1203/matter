class CreateProductCheckers < ActiveRecord::Migration[6.1]
  def change
    create_table :product_checkers do |t|
      t.string :store_name
      t.string :tel1
      t.string :tel2
      t.string :mail1
      t.string :mail2
      t.string :mail3
      t.string :product1
      t.string :product2
      t.string :product3
      t.string :product4
      t.string :product5
      t.string :product6
      t.string :product7
      t.string :product8
      t.string :product9
      t.string :product10
    end
  end
end
