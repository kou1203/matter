class CreateSummitCustomerProps < ActiveRecord::Migration[6.0]
  def change
    create_table :summit_customer_props do |t|
      t.string :start_section
      t.integer :history_record_num     ,nill: false 
      t.string :store_name              ,null: false 
      t.string :history_class          ,nill: false 
      t.string :title                  ,nill: false 
      t.string :status                 ,nill: false 
      t.date :next_response  
      t.text :response_remarks
      t.references :user                ,foreign_key: true 
      t.string :next_response_user
      t.string :summit_user
      t.string :creater
      t.datetime :create_datetime
      t.datetime :response_datetime
      t.string :input_user
      t.string :response_method
      t.text :next_request
      t.string :updater
      t.datetime :update_datetime
      t.integer :target_record_num         ,null: false 
      t.string :supply_num
    end
  end
end
