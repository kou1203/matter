class CreateNuroManagemenetFees < ActiveRecord::Migration[6.1]
  def change
    create_table :nuro_managemenet_fees do |t|
      t.string :service          ,null: false 
      t.integer :price           ,null: false 
      t.integer :fee_len         ,null: false 
      t.date :date               ,null: false 
      t.date :payment            ,null: false 
    end
  end
end
