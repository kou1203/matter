class CreateBaselineMetrics < ActiveRecord::Migration[6.1]
  def change
    create_table :baseline_metrics do |t|
      t.references :baseline_sale, foreign_key: true
      t.string :metric_name, null: false
      t.float :metric_val, null: false
      t.integer :metric_per

    end
  end
end
