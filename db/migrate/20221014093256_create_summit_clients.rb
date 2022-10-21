class CreateSummitClients < ActiveRecord::Migration[6.1]
  def change
    create_table :summit_clients do |t|
      t.references :summit          , foreign_key: true 
      t.date :start_use
      t.string :supply_num
      t.string :pay_menu
      t.text :remarks
      t.date :create_date
      t.date :update_date
      t.integer :target_record_num
      t.string :novice_menu
      t.integer :rate
      t.date :cancel
      t.string :cancel_status
      t.string :cancel_app_company
      t.text :error_contents
      t.string :crepiko_num
    end
  end
end
