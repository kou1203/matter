class CreateAirpayStickers < ActiveRecord::Migration[6.1]
  def change
    create_table :airpay_stickers do |t|
      t.string :category                     ,null: false 
      t.references :user                     , foreign_key: true
      t.string :customer_num                 , null: false
      t.string :store_name
      t.string :form_send_month              ,null: false 
      t.date :form_send                      ,null: false 
      t.string :sticker_ok
      t.string :pop_ok
      t.string :deficiency
      t.integer :valuation                    ,null: false 
      t.integer :profit_sticker               ,null: false 
      t.integer :profit_pop                   ,null: false
      t.text :remarks
    end
  end
end
