class CreatePranesses < ActiveRecord::Migration[6.0]
  def change
    create_table :pranesses do |t|
      t.string :customer_num           , null: false 
      t.string :client
      t.references :user                , foreign_key: true 
      t.references :store_prop          , foreign_key: true 
      t.date :get_date                  , null: false 
      t.date :payment                   , null: false 
      t.string :status                  , null: false
      t.references :stock               , foreign_key: true 
      t.date :ssid_change
      t.string :ssid_1                  , null: false
      t.string :pass_1                  , null: false 
      t.string :ssid_2                  , null: false 
      t.string :pass_2                  , null: false 
      t.date :cancel
      t.string :return_remarks
      t.text :remarks
      t.integer :claim                  , null: false 
      t.date :start                     , null: false 
      t.date :deadline                  , null: false 
      t.date :withdrawal                , null: false 
    end
  end
end