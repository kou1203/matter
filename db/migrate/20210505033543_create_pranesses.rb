class CreatePranesses < ActiveRecord::Migration[6.0]
  def change
    create_table :pranesses do |t|
      t.string :customer_num           , null: false 
      t.string :store_name             , null: false
      t.date :date                     , null: false 
      t.references :user               , foreign_key: true 
      t.string :status                 , null: false
      t.string :cash_status            
      t.string :terminal_num
      t.references :stock              , foreign_key: true
      t.text :remarks
      t.text :sales_man_remarks 
      t.string :terminal_status
      t.string :ssid_1
      t.string :ssid_2
      t.string :pass_1
      t.string :pass_2
      t.date :cancel
      t.text :cancel_reason
      t.string :ssid_pass_change
      t.date :start
      t.date :payment_start
      t.date :first_payment
      t.string :aplus_num
      t.string :cash_name
      t.string :payment_terminal
      t.string :not_use_reason
      t.string :done
      t.string :option
      t.string :mail
      t.date :notice_send
      t.text :def_remarks
      t.date :status_update
    end
  end
end