class CreateAirpays < ActiveRecord::Migration[6.1]
  def change
    create_table :airpays do |t|
      t.string :store_name              ,null: false 
      t.references :user                , foreign_key: true
      t.string :race 
      t.string :corporate_name
      t.date :date                      ,null: false 
      t.string :status                  ,null: false 
      t.string :terminal_status
      t.string :customer_num            ,null: false 
      t.string :kr_code                 ,null: false 
      t.date :result_point
      t.integer :payment
      t.integer :ipad_flag              ,null: false 
      t.integer :vm_status              ,null: false 
      t.integer :vm_status_name         ,null: false 
      t.integer :doc_follow
      t.date :shipping
      t.string :delivery_status
      t.date :activate
      t.integer :valuation              ,null: false 
      t.integer :profit                 ,null: false 
    end
  end
end
