class CreateAirpays < ActiveRecord::Migration[6.1]
  def change
    create_table :airpays do |t|
      t.references :store_prop          , foreign_key: true
      t.references :user                , foreign_key: true
      t.date :date                      ,null: false 
      t.string :client
      t.string :terminal_status
      t.string :status                  ,null: false 
      t.string :customer_num            ,null: false 
      t.string :customer_conf
      t.string :slmt_conf
      t.string :cash_conf
      t.string :doubt_remarks
      t.date :result_point
      t.date :payment
      t.string :qr_flag               
      t.string :ipad_flag               
      t.integer :doc_follow
      t.string :doc_deadline
      t.date :shipping
      t.string :delivery_status
      t.date :activate
      t.integer :valuation              ,null: false 
      t.integer :profit                 ,null: false 
      t.date :status_update
    end
  end
end
