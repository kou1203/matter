class Itss < ApplicationRecord
  require 'charlock_holmes'

  belongs_to :user

  with_options presence: true do 
    validates :customer_num
    validates :user_id
    validates :date
    validates :status_after_call
  end 

  def self.import(file)
    detection = CharlockHolmes::EncodingDetector.detect(File.read(file.path))
    encoding = detection[:encoding] == 'Shift_JIS' ? 'CP932' : detection[:encoding]
    new_cnt = 0
    update_cnt = 0
    nochange_cnt = 0
    CSV.foreach(file.path, encoding: "#{encoding}:UTF-8",headers: true) do |row|
      if (row["東西区分"].present?) && (row["東西区分"] != "")
      user = User.find_by(name: row["営業担当者名"].gsub(" ", ""))
      u_id = user.id rescue 0
      itss = find_by(customer_num: row["管理番号"])
      if (row["【ITSS】N取次状況（大区分）"] == "工事待ち") && (Date.today > row["【ITSS】N工事予定日"].to_date)
        row["【ITSS】N工事予定日"] = nil
      end 
      if itss.present?
        itss.assign_attributes(
          client: "マックスサポート",
          customer_num: row["管理番号"],
          east_or_west: row["東西区分"],
          user_id: u_id,
          date: row["申込日"],
          contract_name: row["【合】契約者名"],
          prefecture: row["都道府県"],
          after_call: row["後確希望時間"],
          status_after_call: row["後確状況"],
          last_call: row["後確最終コール日"],
          after_call_ok: row["後確OK日"],
          p_num: row["P番号"],
          entry_user: row["エントリ担当"],
          status_ntt1: row["【ITSS】N取次状況（大区分）"],
          status_ntt2: row["【ITSS】N取次状況（小区分）"],
          construction_schedule: row["【ITSS】N工事予定日"],
          status_last_history: row["【最終履歴】対応内容"],
          last_history: row["【最終履歴】日時"],
          last_history_remarks: row["【最終履歴】対応詳細"],
          profit: 14000,
          valuation: 4000
        )
        if itss.has_changes_to_save? 
          itss.save!
          itss.assign_attributes(status_update: Date.today)
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        itss = new(
          client: "マックスサポート",
          customer_num: row["管理番号"],
          east_or_west: row["東西区分"],
          user_id: u_id,
          date: row["申込日"],
          contract_name: row["【合】契約者名"],
          prefecture: row["都道府県"],
          after_call: row["後確希望時間"],
          status_after_call: row["後確状況"],
          last_call: row["後確最終コール日"],
          after_call_ok: row["後確OK日"],
          p_num: row["P番号"],
          entry_user: row["エントリ担当"],
          status_ntt1: row["【ITSS】N取次状況（大区分）"],
          status_ntt2: row["【ITSS】N取次状況（小区分）"],
          construction_schedule: row["【ITSS】N工事予定日"],
          status_last_history: row["【最終履歴】対応内容"],
          last_history: row["【最終履歴】日時"],
          last_history_remarks: row["【最終履歴】対応詳細"],
          profit: 14000,
          valuation: 4000
          )
        itss.save!
        new_cnt += 1
      end
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
