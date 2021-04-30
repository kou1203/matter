class CreateDmers < ActiveRecord::Migration[6.0]
  def change
    create_table :dmers do |t|
      t.references :store_prop, foreign_key: true
      t.references :user, foreign_key: true
      t.string :in_charge, null: false 
      t.string :visit_status, null: false 
      t.integer :get_date, null:false 
      t.string :mail, null: false 
      t.text :description
      t.integer :payment
      t.integer :settlement_payment
      t.integer :picture_payment
    end
  end
end
