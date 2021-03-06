class CreateResultSummits < ActiveRecord::Migration[6.1]
  def change
    create_table :result_summits do |t|
      t.references :result                  ,foreign_key: true 
      # 対象外・NG
      t.integer :ng_01
      t.integer :ng_02
      t.integer :ng_03
      # 切り返し    
      t.integer :out_interview_01
      t.integer :out_full_talk_01
      t.integer :out_get_01
      t.integer :out_interview_02
      t.integer :out_full_talk_02
      t.integer :out_get_02
      t.integer :out_interview_03
      t.integer :out_full_talk_03
      t.integer :out_get_03
      t.integer :out_interview_04
      t.integer :out_full_talk_04
      t.integer :out_get_04
      t.integer :out_interview_05
      t.integer :out_full_talk_05
      t.integer :out_get_05
      t.integer :out_interview_06
      t.integer :out_full_talk_06
      t.integer :out_get_06
      t.integer :out_interview_07
      t.integer :out_full_talk_07
      t.integer :out_get_07
      t.integer :out_interview_08
      t.integer :out_full_talk_08
      t.integer :out_get_08
      t.integer :out_interview_09
      t.integer :out_full_talk_09
      t.integer :out_get_09
      t.integer :out_interview_10
      t.integer :out_full_talk_10
      t.integer :out_get_10
      t.integer :out_interview_11
      t.integer :out_full_talk_11
      t.integer :out_get_11
      t.integer :out_interview_12
      t.integer :out_full_talk_12
      t.integer :out_get_12
      t.integer :out_interview_13
      t.integer :out_full_talk_13
      t.integer :out_get_13
      t.integer :out_interview_14
      t.integer :out_full_talk_14
      t.integer :out_get_14
      t.integer :out_interview_15
      t.integer :out_full_talk_15
      t.integer :out_get_15
      t.integer :out_interview_16
      t.integer :out_full_talk_16
      t.integer :out_get_16
      t.integer :out_interview_17
      t.integer :out_full_talk_17
      t.integer :out_get_17
      t.integer :out_interview_18
      t.integer :out_full_talk_18
      t.integer :out_get_18
      t.integer :out_interview_19
      t.integer :out_full_talk_19
      t.integer :out_get_19
      t.integer :out_interview_20
      t.integer :out_full_talk_20
      t.integer :out_get_20
    end
  end
end
