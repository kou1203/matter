class CreateSummits < ActiveRecord::Migration[6.0]
  def change
    create_table :summits do |t|
      t.string :processing_status     
      t.string :record_num             
      t.string :control_num             , null: false
      t.references :store_prop          , foreign_key: true 
      t.string :store_name              , null: false 
      t.date :date                      , null:false 
      t.references :user                , foreign_key: true 
      t.string :power_company
      t.string :power_company_other
      t.string :power_area
      t.string :plan                   
      t.string :contract_type          ,null: false
      t.integer :contract_cap          
      t.string :contract_cap_unit          
      t.date :use_start          
      t.date :use_end          
      t.integer :amount_use            
      t.date :processing_date            
      t.date :arrival_date            
      t.date :summit_start                    
      t.string :customer_num          
      t.string :supply_num             , null: false
      t.string :current_contractor          
      t.string :current_contractor_kana          
      t.string :new_contractor          
      t.string :new_contractor_kana     
      t.string :store_name_kana     
      t.string :destination_item          
      t.string :destination_name          
      t.string :destination_name_kana          
      t.string :billing_item          
      t.string :billing_name          
      t.string :billing_name_kana          
      t.string :billing_name_mail          
      t.string :crepiko_num               
      t.text :remarks               
      t.integer :fc_num               
      t.date :mail_send               
      t.string :status                 , null: false                  
      t.integer :profit        
      t.date :payment               
      t.date :status_update
    end
  end
end
