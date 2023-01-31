class CreateItsses < ActiveRecord::Migration[6.1]
  def change
    create_table :itsses do |t|
      t.string :client          
      t.string :customer_num            ,null: false      
      t.string :east_or_west          
      t.references :user                ,foreign_key: true 
      t.date :date                      ,null: false
      t.string :contract_name          
      t.string :prefecture             
      t.date :after_call             
      t.string :status_after_call         ,null: false             
      t.date :last_call                
      t.date :after_call_ok             
      t.string :p_num             
      t.string :entry_user             
      t.string :status_ntt1             
      t.string :status_ntt2                          
      t.date :construction_schedule             
      t.date :last_history             
      t.string :status_last_history             
      t.text :last_history_remarks             
      t.date :status_update     
      t.integer :profit        
      t.integer :valuation        

    end
  end
end
