class CreateSummitErrorHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :summit_error_histories do |t|
      t.string :start_section
      t.integer :error_record_num          ,null: false 
      t.string :store_name                 ,null: false 
      t.string :status                     ,null: false 
      t.string :error_class      
      t.string :error_class2     
      t.string :not_payment_month
      t.integer :price        
      t.string :arrears_flag        
      t.string :arrears_contains        
      t.date :payment
      t.date :next_response   
      t.text :response_remarks
      t.references :user                   ,foreign_key: true
      t.string :next_response_user
      t.string :summit_user
      t.datetime :create_datetime
      t.integer :target_record_num         ,null: false 
      t.datetime :create_date
      t.string :input_user
      t.string :response_place
      t.string :response_method
      t.text :next_request
    end
  end
end
