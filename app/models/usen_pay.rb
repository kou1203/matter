class UsenPay < ApplicationRecord
  belongs_to :user 

  with_options presence: true do 
    validates :controll_num
    validates :store_name
    validates :user_id
    validates :date
    validates :status
    validates :profit
    validates :valuation
  end 


  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"]) rescue ""
      errors << "#{index}行目獲得者が不正です" if user.blank? && errors.length < 5
        u_id = user.id if user.present? && errors.length < 5
        usen_pay = new(
          controll_num: row["案件番号"],
          store_name: row["店舗名"],
          status: row["ステータス"],
          user_id: u_id,
          date: row["U-Pay"],
          remarks: row["備考"],
          share: row["連携日"],
          def_remarks: row["不備詳細"],
          doc_status: row["書類ステータス"],
          def_solution: row["不備解消日"],
          profit: 0,
          valuation: 0
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if usen_pay.invalid? && errors.length < 5
    end
    errors
  end

  def self.import(file)
    new_cnt = 0
    update_cnt = 0
    nochange_cnt = 0
    CSV.foreach(file.path, headers: true) do |row|
      user = User.find_by(name: row["獲得者"])
      u_id = user.id if user.present?
      usen_pay = find_by(controll_num: row["案件番号"])
      if usen_pay.present?
        usen_pay.assign_attributes(
          controll_num: row["案件番号"],
          store_name: row["店舗名"],
          status: row["ステータス"],
          user_id: u_id,
          date: row["U-Pay"],
          remarks: row["備考"],
          share: row["連携日"],
          def_remarks: row["不備詳細"],
          doc_status: row["書類ステータス"],
          def_solution: row["不備解消日"],
          profit: 0,
          valuation: 0
        )
        if usen_pay.has_changes_to_save? 
          usen_pay.save!
          usen_pay.assign_attributes(status_update: Date.today)
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        usen_pay = new(
          controll_num: row["案件番号"],
          store_name: row["店舗名"],
          status: row["ステータス"],
          user_id: u_id,
          date: row["U-Pay"],
          remarks: row["備考"],
          share: row["連携日"],
          def_remarks: row["不備詳細"],
          doc_status: row["書類ステータス"],
          def_solution: row["不備解消日"],
          profit: 0,
          valuation: 0
          )
        usen_pay.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
