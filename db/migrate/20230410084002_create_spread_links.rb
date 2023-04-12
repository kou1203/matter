class CreateSpreadLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :spread_links do |t|

      t.integer :year          , null: false
      t.integer :month         , null: false
      t.string :name
      t.string :original_url   , null: false
      t.string :search_url     , null: false
    end
  end
end
