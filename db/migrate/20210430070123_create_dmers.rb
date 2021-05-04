class CreateDmers < ActiveRecord::Migration[6.0]
  def change
    create_table :dmers do |t|
      t.references :store_prop, foreign_key: true
      t.references :user, foreign_key: true
      t.string :status, null: false 
      t.date :get_date, null:false 
      t.string :mail, null: false 
      t.text :description
      t.date :payment
      t.date :settlement_payment
      t.date :picture_payment
    end
  end
end
