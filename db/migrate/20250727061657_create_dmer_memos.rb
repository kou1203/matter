class CreateDmerMemos < ActiveRecord::Migration[6.1]
  def change
    create_table :dmer_memos do |t|
      t.string :memo
      t.date :date
      t.string :status
      t.references :dmer_senbai, foreign_key: true
    end
  end
end
