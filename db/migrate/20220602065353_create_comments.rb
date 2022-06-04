class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :store_prop     ,foreign_key: true
      t.string :product            ,null: false 
      t.string :content            ,null: false 
      t.string :status             ,null: false 
      t.string :ball            
      t.date :request            
      t.text :request_show            
      t.date :response            
      t.text :response_show            
      t.date :done                              
      t.timestamps
    end
  end
end
