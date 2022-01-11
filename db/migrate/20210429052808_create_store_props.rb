class CreateStoreProps < ActiveRecord::Migration[6.0]
  def change
    create_table :store_props do |t|
      t.string :race                   
      t.string :name                    , null: false 
      t.string :industry                
      t.string :head_store
      t.string :corporate_name
      t.text :corporate_address
      t.string :corporate_num
      t.string :gender_main             , null: false 
      t.string :person_main_name        , null: false 
      t.string :person_main_kana        , null: false 
      t.string :person_main_class       
      t.date :person_main_birthday
      t.string :gender_sub            
      t.string :person_sub_name 
      t.string :person_sub_kana
      t.string :person_sub_class
      t.date :person_sub_birthday
      t.string :phone_number_1          , null: false 
      t.string :phone_number_2 
      t.string :mail_1                
      t.string :mail_2 
      t.string :prefecture             , null: false 
      t.string :city                   , null: false 
      t.string :municipalities         , null: false 
      t.string :address                , null: false 
      t.string :building_name
      t.string :suitable_time         
      t.string :holiday       
      t.string :description
      
    end
  end
end