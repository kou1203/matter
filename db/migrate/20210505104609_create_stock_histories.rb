class CreateStockHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :stock_histories do |t|
      t.references :user, foreign_key: true 
      t.references :stock, foreign_key: true 
      t.date :take_out
    end
  end
end
