class CreateBaselineSales < ActiveRecord::Migration[6.1]
  def change
    create_table :baseline_sales do |t|
      t.integer :sales_goal, null: false
    end
  end
end
