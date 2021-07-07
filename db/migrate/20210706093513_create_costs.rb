class CreateCosts < ActiveRecord::Migration[6.0]
  def change
    create_table :costs do |t|
      t.integer :year                            ,null: false 
      t.integer :month                           ,null: false 
      t.string :base                            ,null: false
      t.integer :sales_man                       ,null: false 
      t.integer :office_worker                   ,null: false 
      t.integer :social_insurance                ,null: false 
      t.integer :administrator                   ,null: false 
      t.integer :sales_man_cost                  ,null: false 
      t.integer :office_worker_cost              ,null: false 
      t.integer :office                          ,null: false 
      t.integer :utility_net_cost                ,null: false 
      t.integer :dorm                            ,null: false 
      t.integer :bonus_stock                     ,null: false 
      t.integer :travel_stock                    ,null: false 
      t.integer :other                           ,null: false 
      t.date :update_date
    end
  end
end
