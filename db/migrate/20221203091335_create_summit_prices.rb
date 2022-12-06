class CreateSummitPrices < ActiveRecord::Migration[6.1]
  def change
    create_table :summit_prices do |t|
      t.references :summit ,foreign_key: true
      t.integer :record_num
      t.integer :first_billing
      t.integer :last_billing
    end
  end
end
