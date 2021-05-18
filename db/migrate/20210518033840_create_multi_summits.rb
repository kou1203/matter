class CreateMultiSummits < ActiveRecord::Migration[6.0]
  def change
    create_table :multi_summits do |t|
      t.references :summit     , foreign_key: true 
      t.string :customer_num   , null: false 
      t.string :supply_num
      t.date :payment
      t.date :get_date         , null: false 
    end
  end
end
