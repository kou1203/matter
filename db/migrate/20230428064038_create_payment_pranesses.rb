class CreatePaymentPranesses < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_pranesses do |t|
      t.references :praness               , foreign_key: true 
      t.string :store_name                , null: false
      t.string :aplus_customer_num        
      t.integer :price                    
      t.integer :price_tax                
      t.string :payment_date              
      t.string :status                    ,null: false
      t.string :payment_method            
      t.date :payment_schedule            
      t.date :payment                     
      t.date :status_update                     
      t.text :remarks                     

    end
  end
end
