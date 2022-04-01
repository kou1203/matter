class ResultCash < ApplicationRecord
  belongs_to :result

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["ユーザー名"])
      errors << "ユーザー名が不正です" if user.blank? && errors.length < 5
        u_id = user.id if user.present?
        result = Result.find_by(user_id: u_id, date: row["日付"])
        r_id = result.id if result.present?
        result_cash = new(
          result_id: r_id,
          out_interview_01: row["切り返し1対面"],
          out_full_talk_01: row["切り返し1フル"],
          out_get_01: row["切り返し1獲得"],
          out_interview_02: row["切り返し2対面"],
          out_full_talk_02: row["切り返し2フル"],
          out_get_02: row["切り返し2獲得"],
          out_interview_03: row["切り返し3対面"],
          out_full_talk_03: row["切り返し3フル"],
          out_get_03: row["切り返し3獲得"],
          out_interview_04: row["切り返し4対面"],
          out_full_talk_04: row["切り返し4フル"],
          out_get_04: row["切り返し4獲得"],
          out_interview_05: row["切り返し5対面"],
          out_full_talk_05: row["切り返し5フル"],
          out_get_05: row["切り返し5獲得"],
          out_interview_06: row["切り返し6対面"],
          out_full_talk_06: row["切り返し6フル"],
          out_get_06: row["切り返し6獲得"],
          out_interview_07: row["切り返し7対面"],
          out_full_talk_07: row["切り返し7フル"],
          out_get_07: row["切り返し7獲得"],
          out_interview_08: row["切り返し8対面"],
          out_full_talk_08: row["切り返し8フル"],
          out_get_08: row["切り返し8獲得"],
          out_interview_09: row["切り返し9対面"],
          out_full_talk_09: row["切り返し9フル"],
          out_get_09: row["切り返し9獲得"],
          out_interview_10: row["切り返し10対面"],
          out_full_talk_10: row["切り返し10フル"],
          out_get_10: row["切り返し10獲得"],
          out_interview_11: row["切り返し11対面"],
          out_full_talk_11: row["切り返し11フル"],
          out_get_11: row["切り返し11獲得"],
          out_interview_12: row["切り返し12対面"],
          out_full_talk_12: row["切り返し12フル"],
          out_get_12: row["切り返し12獲得"],
          out_interview_13: row["切り返し13対面"],
          out_full_talk_13: row["切り返し13フル"],
          out_get_13: row["切り返し13獲得"]
        )
        errors << "#{index}行目,「#{row["日付"]}」のデータが保存できませんでした" if result_cash.invalid? && errors.length < 5
    end
    errors
  end

  def self.import(file)
    detection = CharlockHolmes::EncodingDetector.detect(File.read(file.path))
    encoding = detection[:encoding] == 'Shift_JIS' ? 'CP932' : detection[:encoding]
    new_cnt = 0
    update_cnt = 0
    nochange_cnt = 0
    CSV.foreach(file.path, encoding: "#{encoding}:UTF-8",headers: true) do |row|
      user = User.find_by(name: row["ユーザー名"])
      u_id = user.id if user.present?
      result = Result.find_by(user_id: u_id, date: row["日付"])
      r_id = result.id if result.present?
      result_cash = ResultCash.find_by(result_id: r_id)
      if result_cash.present? 
        result_cash.assign_attributes(
          result_id: r_id,
          out_interview_01: row["切り返し1対面"],
          out_full_talk_01: row["切り返し1フル"],
          out_get_01: row["切り返し1獲得"],
          out_interview_02: row["切り返し2対面"],
          out_full_talk_02: row["切り返し2フル"],
          out_get_02: row["切り返し2獲得"],
          out_interview_03: row["切り返し3対面"],
          out_full_talk_03: row["切り返し3フル"],
          out_get_03: row["切り返し3獲得"],
          out_interview_04: row["切り返し4対面"],
          out_full_talk_04: row["切り返し4フル"],
          out_get_04: row["切り返し4獲得"],
          out_interview_05: row["切り返し5対面"],
          out_full_talk_05: row["切り返し5フル"],
          out_get_05: row["切り返し5獲得"],
          out_interview_06: row["切り返し6対面"],
          out_full_talk_06: row["切り返し6フル"],
          out_get_06: row["切り返し6獲得"],
          out_interview_07: row["切り返し7対面"],
          out_full_talk_07: row["切り返し7フル"],
          out_get_07: row["切り返し7獲得"],
          out_interview_08: row["切り返し8対面"],
          out_full_talk_08: row["切り返し8フル"],
          out_get_08: row["切り返し8獲得"],
          out_interview_09: row["切り返し9対面"],
          out_full_talk_09: row["切り返し9フル"],
          out_get_09: row["切り返し9獲得"],
          out_interview_10: row["切り返し10対面"],
          out_full_talk_10: row["切り返し10フル"],
          out_get_10: row["切り返し10獲得"],
          out_interview_11: row["切り返し11対面"],
          out_full_talk_11: row["切り返し11フル"],
          out_get_11: row["切り返し11獲得"],
          out_interview_12: row["切り返し12対面"],
          out_full_talk_12: row["切り返し12フル"],
          out_get_12: row["切り返し12獲得"],
          out_interview_13: row["切り返し13対面"],
          out_full_talk_13: row["切り返し13フル"],
          out_get_13: row["切り返し13獲得"]
        )
        if result.has_changes_to_save? 
          result_cash.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        result_cash = new(
          result_id: r_id,
          out_interview_01: row["切り返し1対面"],
          out_full_talk_01: row["切り返し1フル"],
          out_get_01: row["切り返し1獲得"],
          out_interview_02: row["切り返し2対面"],
          out_full_talk_02: row["切り返し2フル"],
          out_get_02: row["切り返し2獲得"],
          out_interview_03: row["切り返し3対面"],
          out_full_talk_03: row["切り返し3フル"],
          out_get_03: row["切り返し3獲得"],
          out_interview_04: row["切り返し4対面"],
          out_full_talk_04: row["切り返し4フル"],
          out_get_04: row["切り返し4獲得"],
          out_interview_05: row["切り返し5対面"],
          out_full_talk_05: row["切り返し5フル"],
          out_get_05: row["切り返し5獲得"],
          out_interview_06: row["切り返し6対面"],
          out_full_talk_06: row["切り返し6フル"],
          out_get_06: row["切り返し6獲得"],
          out_interview_07: row["切り返し7対面"],
          out_full_talk_07: row["切り返し7フル"],
          out_get_07: row["切り返し7獲得"],
          out_interview_08: row["切り返し8対面"],
          out_full_talk_08: row["切り返し8フル"],
          out_get_08: row["切り返し8獲得"],
          out_interview_09: row["切り返し9対面"],
          out_full_talk_09: row["切り返し9フル"],
          out_get_09: row["切り返し9獲得"],
          out_interview_10: row["切り返し10対面"],
          out_full_talk_10: row["切り返し10フル"],
          out_get_10: row["切り返し10獲得"],
          out_interview_11: row["切り返し11対面"],
          out_full_talk_11: row["切り返し11フル"],
          out_get_11: row["切り返し11獲得"],
          out_interview_12: row["切り返し12対面"],
          out_full_talk_12: row["切り返し12フル"],
          out_get_12: row["切り返し12獲得"],
          out_interview_13: row["切り返し13対面"],
          out_full_talk_13: row["切り返し13フル"],
          out_get_13: row["切り返し13獲得"]
          )
          result_cash.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
