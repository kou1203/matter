class CreateDmerSenbais < ActiveRecord::Migration[6.1]
  def change
    create_table :dmer_senbais do |t|
      t.string :client                          ,null: false 
      t.string :store_code                      ,null: false 
      t.string :customer_num                    ,null: false 
      t.string :industry                        ,null: false 
      t.string :category                        ,null: false 
      t.string :store_name                      ,null: false 
      t.date :date                              ,null: false 
      t.references :user                        ,foreign_key: true 
      t.references :settlementer
      t.string :industry_status     
      t.string :app_check          
      t.date :app_check_date      
      t.string :dup_check          
      t.date :enter_store      
      t.date :reg_store       
      t.string :status                          ,null: false         
      t.string :partner_status                  ,null: false         
      t.string :status_settlement               ,null: false         
      t.date :result_point      
      t.date :shipment     
      t.date :settlement     
      t.date :settlement_second
      t.date :settlement_deadline               ,null: false
      t.date :picture     
      t.date :picture_latest
      t.string :picture_check
      t.date :picture_check_date
      t.date :dpay_slmt_latest
      t.date :merpay_slmt_latest
      t.text :deficiency_remarks
      t.string :post_code                       ,null: false
      t.string :prefecture                      ,null: false
      t.string :city                            ,null: false
      t.string :address                         ,null: false
      t.integer :valuation_new                  ,null: false
      t.integer :valuation_settlement           ,null: false
      t.integer :valuation_second_settlement    ,null: false
      t.integer :profit                         ,null: false
      t.date :status_update
    end
    add_foreign_key :dmer_senbais,:users, column: :settlementer_id
  end
end
