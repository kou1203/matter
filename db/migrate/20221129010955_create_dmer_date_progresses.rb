class CreateDmerDateProgresses < ActiveRecord::Migration[6.1]
  def change
    create_table :dmer_date_progresses do |t|
      t.references :user                     , foreign_key: true
      t.string :base
      t.date :date                           , null: false
      t.integer :shift_schedule
      t.integer :shift_digestion
      t.integer :get_len
      t.integer :def_len
      t.integer :fin_len
      t.integer :valuation_current
      t.integer :valuation_current1
      t.integer :valuation_current2
      t.integer :valuation_current3
      t.integer :valuation_fin1
      t.integer :valuation_fin2
      t.integer :valuation_fin3
      t.integer :valuation_fin1_prev
      t.integer :valuation_fin2_prev
      t.integer :valuation_fin3_prev
      t.integer :profit_current
      t.integer :profit_current1
      t.integer :profit_current2
      t.integer :profit_current3
      t.integer :profit_fin1
      t.integer :profit_fin2
      t.integer :profit_fin3
      t.integer :profit_fin1_prev
      t.integer :profit_fin2_prev
      t.integer :profit_fin3_prev
      # 各種獲得数
      t.integer :done_len
      t.integer :slmt_dead_len
      t.integer :result1_len
      t.integer :result2_len
      t.integer :result3_len
      t.integer :result1_fin_len
      t.integer :result2_fin_len
      t.integer :result3_fin_len
      # 各種獲得数（過去月）
      t.integer :slmt_tgt_prev
      t.integer :done_len_prev
      t.integer :result1_len_prev
      t.integer :result2_len_prev
      t.integer :result3_len_prev
      t.date :create_date                   ,  null: false
    end
  end
end
