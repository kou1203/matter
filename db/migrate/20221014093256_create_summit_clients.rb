class CreateSummitClients < ActiveRecord::Migration[6.1]
  def change
    create_table :summit_clients do |t|
      t.references :summit          , foreign_key: true 
      t.string :area
      t.date :start_use
      t.date :change_date
      t.string :supply_num
      t.string :store_name
      t.string :low_voltage_contract_id
      t.string :pay_menu
      t.text :remarks
      t.string :summit_manger
      t.date :create_date
      t.date :update_date
      t.integer :target_record_num
      t.string :updater
      t.string :creater
      t.string :contact_num
      t.string :novice_menu
      t.string :start_status
      t.string :start_cancel_status
      t.string :agency_status
      t.date :contract_start
      t.date :contract_end
      t.string :customer_name
      t.integer :rate
      t.string :salesman_partner_id
      t.string :salesman_user_id
      t.string :partner_name
      t.string :contract_partner
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_mail
      t.string :salesman
      t.string :start_app_company
      t.string :cancel_class
      t.string :cancel_status
      t.date :cancel
      t.string :cancel_app_company
      t.string :start_company_contract_num
      t.text :error_contents
      t.string :crepiko_num
      t.date :status_update
    end
  end
end
