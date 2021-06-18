class CreateTroubleNs < ActiveRecord::Migration[6.0]
  def change
    create_table :trouble_ns do |t|
      t.string :base                  ,null: false
      t.date :date                    ,null: false
      t.string :category              ,null: false
      t.string :customer_name         ,null: false
      t.string :get_status            ,null: false
      t.string :contract_type         ,null: false
      t.references :user              ,foreign_key: true 
      t.string :confirmer             
      t.string :customer_caller       ,null: false
      t.string :content_type          ,null: false
      t.text :customer_opinion       
      t.text :user_opinion           
      t.text :result                 
      
    end
  end
end
