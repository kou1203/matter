class CreateSummits < ActiveRecord::Migration[6.0]
  def change
    create_table :summits do |t|
      t.references :summit_customer_prop, foreign_key: true 
      t.references :user                , foreign_key: true 
      t.date :get_date                  , null:false 
      t.integer :payment               
      t.string :status                  , null: false 
      t.string :before_status
      t.string :supply_num             , null: false 
      t.string :contract_num
      t.string :menu                   , null: false 
      t.string :plan                   
      t.string :contract_type          
      t.integer :contract_cap          
      t.string :contract_cap_unit      
      t.integer :amount_use            
      t.date :start                    
      t.integer :claim                 
      t.integer :claim_expected        
      t.string :remarks
      t.string :power_company
    end
  end
end
