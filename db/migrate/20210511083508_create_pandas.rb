class CreatePandas < ActiveRecord::Migration[6.0]
  def change
    create_table :pandas do |t|
      t.string :customer_num             , null: false 
      t.string :client                   ,null: false
      t.references :user                 , foreign_key: true
      t.references :store_prop           , foreign_key: true 
      t.date :get_date                   , null: false 
      t.date :payment 
      t.string :status                   , null: false 
      t.string :before_status
      t.string :image_status             ,null: false 
      t.string :grid_id
      t.string :food_category            , null: false 
      t.string :ghost_flag               , null: false 
      t.date :docu_sign_send
      t.date :docu_sign_done
      t.string :confirmer
      t.date :solution_date
      t.text :remarks 
      t.date :confirm_date
      t.date :tarminal_send
      t.date :result_point

    end
    add_index :pandas, [:customer_num], unique: true
  end
end
