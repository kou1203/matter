class CreateSummits < ActiveRecord::Migration[6.0]
  def change
    create_table :summits do |t|
      t.references :user, foreign_key: true 
      t.references :store_prop, foreign_key: true 
      t.date :get_date, null:false 
      t.string :claim_house, null: false 
      t.string :claim_address, null: false 
      t.string :mail, null: false 
      t.string :before_electric
      t.integer :supply_num
      t.string :pay_as
      t.string :weight
      t.string :menu, null:false 
      t.date :start, null: false 
      t.integer :fee
      t.date :payment, null: false 
      t.string :remarks
      t.string :client
    end
  end
end
