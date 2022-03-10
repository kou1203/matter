class CreateAupays < ActiveRecord::Migration[6.0]
  def change
    create_table :aupays do |t|
      t.string :customer_num           
      t.string :client               
      t.references :user                , foreign_key: true
      t.references :store_prop          , index: { unique: true }, foreign_key: true
      t.date :date                      , null:false 
      t.date :share 
      t.string :status                  , null: false 
      t.date :status_update
      t.references :settlementer
      t.date :shipment
      t.date :settlement
      t.date :picture
      t.date :settlement_deadline
      t.string :status_settlement     
      t.date :status_update_settlement
      t.date :payment
      t.date :payment_settlement
      t.date :result_point
      t.date :result_point_settlement
      t.date :deficiency
      t.date :deficiency_settlement
      t.date :deficiency_solution
      t.date :deficiency_solution_settlement
      t.date :deficiency_deadline
      t.text :deficiency_remarks
      t.text :deficiency_remarks_settlement
      t.text :description
      t.integer :profit_new             ,null: false
      t.integer :profit_settlement       ,null: false
      t.integer :valuation_new           ,null: false 
      t.integer :valuation_settlement    , null: false
    end
    add_foreign_key :aupays, :users, column: :settlementer_id
  end
end
