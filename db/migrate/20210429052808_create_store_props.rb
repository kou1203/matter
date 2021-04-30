class CreateStoreProps < ActiveRecord::Migration[6.0]
  def change
    create_table :store_props do |t|
      t.string :race
      t.string :name,               null: false 
      t.string :suitable_time,      null: false
      t.text :description
      t.string :industry,           null: false
      t.string :phone_number_1,       null: false 
      t.string :phone_number_2 
      t.string :person,             null: false 
      t.string :prefectures,        null: false 
      t.string :city,               null: false 
      t.string :municipalities,     null: false 
      t.string :address,            null: false 
      t.string :building_name
  
    end
  end
end
