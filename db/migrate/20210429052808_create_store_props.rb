class CreateStoreProps < ActiveRecord::Migration[6.0]
  def change
    create_table :store_props do |t|
      t.string :race
      t.string :name                   , null: false 
      t.string :corporate_name
      t.string :industry               , null: false
      t.string :description
      t.string :phone_number_1         , null: false 
      t.string :phone_number_2 
      t.string :person_main            , null: false 
      t.string :person_main_kana       , null: false 
      t.date :birthday
      t.string :person_sub 
      t.string :person_sub_kana
      t.string :mail_1                 , null: false 
      t.string :mail_2 
      t.string :prefecture             , null: false 
      t.string :city                   , null: false 
      t.string :municipalities         , null: false 
      t.string :address                , null: false 
      t.string :building_name
      t.string :suitable_time          , null: false
      t.string :holiday                , null: false 
      t.string :head_store
  
    end
    add_index :store_props , [:name], unique: true
  end
end