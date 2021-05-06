class CreateReturnHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :return_histories do |t|
      t.references :user, foreign_key: true 
      t.references :stock, foreign_key: true 
      t.date :return
    end
  end
end
