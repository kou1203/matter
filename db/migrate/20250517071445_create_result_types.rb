class CreateResultTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :result_types do |t|
      t.references :result, foreign_key: true
      t.string :visit_type, null: false
    end
  end
end
