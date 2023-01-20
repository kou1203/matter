class CreateAirpaystickerDateProgresses < ActiveRecord::Migration[6.1]
  def change
    create_table :airpaysticker_date_progresses do |t|
      t.references :user                     , foreign_key: true
      t.string :base
      t.date :date                           , null: false
      t.integer :shift_schedule
      t.integer :shift_digestion
      t.integer :get_len
      t.integer :fin_len
      t.integer :valuation_current
      t.integer :valuation_fin
      t.integer :profit_current
      t.integer :profit_fin
      t.integer :result_len
      t.integer :result_fin_len
      t.date :create_date                   ,  null: false
    end
  end
end
