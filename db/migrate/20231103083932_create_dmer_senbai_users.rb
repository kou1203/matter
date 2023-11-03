class CreateDmerSenbaiUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :dmer_senbai_users do |t|
      t.references :user       ,foreign_key: true 
      t.string :client         ,null: false
      t.date :date             , null: false
      
    end
  end
end
