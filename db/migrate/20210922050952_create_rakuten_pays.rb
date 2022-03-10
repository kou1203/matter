class CreateRakutenPays < ActiveRecord::Migration[6.1]
  def change
    create_table :rakuten_pays do |t|
      t.string :client                 , null: false 
      t.references :user               , foreign_key: true 
      t.references :store_prop         , index: { unique: true }, foreign_key: true 
      t.date :date                     , null: false 
      t.date :share
      t.string :status                 , null: false 
      t.string :transcript
      t.string :customer_num
      t.date :status_update
      t.date :deficiency
      t.date :deficiency_solution
      t.text :deficiency_info
      t.text :deficiency_consent
      t.date :result_point
      t.date :payment
      t.integer :profit             ,null: false
      t.integer :valuation          ,null: false
    end
  end
end
