class CreateNuroPayments < ActiveRecord::Migration[6.1]
  def change
    create_table :nuro_payments do |t|
      t.references :nuro            ,foreign_key: true
      t.string :category            ,null: false
      t.string :isp_num             ,null: false
      t.string :name                ,null: false
      t.string :service             ,null: false
      t.date :payment               ,null: false
      t.integer :price              ,null: false
    end
  end
end
