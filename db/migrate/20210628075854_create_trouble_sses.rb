class CreateTroubleSses < ActiveRecord::Migration[6.0]
  def change
    create_table :trouble_sses do |t|
      t.date :date                ,null: false 
      t.references :store_prop    ,foreign_key: true 
      t.string :category          ,null: false 
      t.string :customer_name     ,null: false 
      t.string :get_status        ,null: false 
      t.string :product           ,null: false 
      t.references :user          ,foreign_key: true 
      t.string :confirmer         ,null: false 
      t.string :content_type      ,null: false
      t.text :customer_opinion    ,null: false
      t.date :contact_date
      t.text :result
      t.text :remarks
    end
  end
end
