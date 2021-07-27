class CreatePandas < ActiveRecord::Migration[6.0]
  def change
    create_table :pandas do |t|
      t.string :grid_id
      t.string :food_category            , null: false 
      t.string :client
      t.references :user                 , foreign_key: true
      t.references :store_prop           , foreign_key: true 
      t.date :get_date                   , null: false 
      t.string :ghost_flag             
      t.date :docu_sign_send
      t.date :docu_sign_done
      t.date :quality_check
      t.date :delivery_arrangements
      t.string :traning
      t.date :result_point
      t.date :payment 
      t.text :remarks 
      t.string :status               
      t.date :status_update
      t.string :confirm_ball
      t.date :confirm_date
      t.string :confirmer
      t.text :deficiency
      t.text :deficiency_result
      t.date :solution_date
      t.integer :valuation_profit     ,null: false
      t.integer :actual_profit        ,null: false
    end
    add_index :pandas, [:grid_id], unique: true
  end
end
