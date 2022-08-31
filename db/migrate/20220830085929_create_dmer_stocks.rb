class CreateDmerStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :dmer_stocks do |t|
      t.string :client, null: false
      t.date :date, null: false
      t.string :base, null: false
      t.integer :stock_len, null: false
    end
  end
end
