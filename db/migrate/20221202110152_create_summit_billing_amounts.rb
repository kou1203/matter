class CreateSummitBillingAmounts < ActiveRecord::Migration[6.1]
  def change
    create_table :summit_billing_amounts do |t|
      t.string :first_flag
      t.string :base
      t.string :prefecture
      t.string :billing_date
      t.string :store_name 
      t.string :contract_type
      t.integer :total_use
      t.integer :billing_amount
      t.integer :commission
      t.integer :commission_tax_included
      t.integer :record_num
      t.references :user             ,foreign_key: true
      t.references :summit           ,foreign_key: true
      t.date :payment_date
    end
  end
end
