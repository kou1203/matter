class CreateSelectColumns < ActiveRecord::Migration[6.1]
  def change
    create_table :select_columns do |t|
      t.string :category  ,null: false 
      t.string :name      ,null: false 
    end
  end
end
