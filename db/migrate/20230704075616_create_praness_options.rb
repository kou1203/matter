class CreatePranessOptions < ActiveRecord::Migration[6.1]
  def change
    create_table :praness_options do |t|
      t.string     :customer_num        ,null: false
      t.string     :store_name          ,null: false 
      t.references :praness             ,foreign_key: true 
      t.references :user                ,foreign_key: true 
      t.date       :date                ,null: false 
      t.date       :cancel              
      t.date       :start               
      t.string     :option_customer_num 
      t.integer    :price               ,null: false 
      t.integer    :price_tax           ,null: false 
      t.date       :payment_date        ,null: false 
      t.string     :status              ,null: false 
      t.string     :payment_method      
      t.date       :payment_schedule    
      t.date       :payment             
      t.text       :remarks             
      t.date       :status_update       
    end
  end
end
