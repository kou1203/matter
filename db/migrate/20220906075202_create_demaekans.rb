class CreateDemaekans < ActiveRecord::Migration[6.1]
  def change
    create_table :demaekans do |t|
      t.string :status           , null: false 
      t.date :date               , null: false
      t.references :user         , foreign_key: true
      t.references :store_prop   , foreign_key: true
      t.date :cs_send
      t.date :datedeadline
      t.date :first_cs_contract
    end
  end
end
