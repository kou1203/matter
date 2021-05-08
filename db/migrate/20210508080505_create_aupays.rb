class CreateAupays < ActiveRecord::Migration[6.0]
  def change
    create_table :aupays do |t|
      t.references :store_prop, foreign_key: true
      t.references :user, foreign_key: true 
      t.date :get_date, null: false 
      t.string :status, null: false 
      t.string :mail, null: false 
      t.string :client, null: false 
      t.date :payment
      t.date :settlement
      t.string :description
    end
  end
end
