class CreateUsenPays < ActiveRecord::Migration[6.1]
  def change
    create_table :usen_pays do |t|
      t.string :controll_num             ,null: false 
      t.string :store_name               ,null: false 
      t.references :user                 ,foreign_key: true
      t.date :date                       ,null: false
      t.string :status                   ,null: false 
      t.string :doc_status               
      t.text :def_remarks                
      t.date :deficiency                 
      t.date :def_solution               
      t.date :share                      
      t.date :result_point                      
      t.text :remarks                    
      t.integer :profit                  ,null: false 
      t.integer :valuation               ,null: false 
      t.date :status_update
    end
  end
end
