class CreateReversalProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :reversal_products do |t|
      t.string :product           ,null: false
      t.string :store_name        ,null: false
      t.references :user          ,foreign_key: true
      t.date :date                ,null: false
      t.date :result_date         ,null: false
      t.date :reversal_date       ,null: false
      t.integer :price            ,null: false

    end
  end
end
