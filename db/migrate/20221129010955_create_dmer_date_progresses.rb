class CreateDmerDateProgresses < ActiveRecord::Migration[6.1]
  def change
    create_table :dmer_date_progresses do |t|
      t.references :user                     , foreign_key: true
      t.date :date                           , null: false
      t.integer :shift_schedule
      t.integer :shift_digestion
      t.integer :get_len
      t.integer :def_len
      t.integer :fin_len
      t.integer :valuation_current
      t.integer :valuation_fin
      t.integer :profit_current
      t.integer :profit_fin
      # 各種獲得数
      t.integer :wait_len
      t.integer :done_len
      t.integer :slmt_dead_len
      t.integer :result1_len
      t.integer :result2_len
      t.integer :result3_len
      # 各種獲得数（過去月）
      t.integer :wait_len_prev
      t.integer :done_len_prev
      t.integer :result1_len_prev
      t.integer :result2_len_prev
      t.integer :result3_len_prev
      t.date :create_date                   ,  null: false
    end
  end
end
