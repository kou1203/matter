class CreateDealAttributes < ActiveRecord::Migration[6.1]
  def change
    create_table :deal_attributes do |t|

      t.references :result_type, foreign_key: true
      t.string :key, null: false
      t.integer :val
    end
  end
end
