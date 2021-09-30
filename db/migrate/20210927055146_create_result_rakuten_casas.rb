class CreateResultRakutenCasas < ActiveRecord::Migration[6.1]
  def change
    create_table :result_rakuten_casas do |t|
      # NG
      t.references :result , foreign_key: true 
      t.integer :ng_lack_info
      # 忙しい
      t.integer :busy_interview
      t.integer :busy_full_talk
      t.integer :busy_get
      # めんどくさい
      t.integer :dull_interview
      t.integer :dull_full_talk
      t.integer :dull_get
      # 置く場所がない
      t.integer :not_put_space_interview
      t.integer :not_put_space_full_talk
      t.integer :not_put_space_get
      # メリットない
      t.integer :no_merit_interview
      t.integer :no_merit_full_talk
      t.integer :no_merit_get
      # 不審
      t.integer :distrust_interview
      t.integer :distrust_full_talk
      t.integer :distrust_get
      # 回線使われたくない
      t.integer :not_use_net_interview
      t.integer :not_use_net_full_talk
      t.integer :not_use_net_get
      # 結構です
      t.integer :not_need_interview
      t.integer :not_need_full_talk
      t.integer :not_need_get
      # ぺろ
      t.integer :easy_interview
      t.integer :easy_full_talk
      t.integer :easy_get
      # その他
      t.integer :other_interview
      t.integer :other_full_talk
      t.integer :other_get
    end
  end
end
