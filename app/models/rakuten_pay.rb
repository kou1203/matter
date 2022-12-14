class RakutenPay < ApplicationRecord
  belongs_to :user 
  belongs_to :store_prop

  with_options presence: true do 
    validates :user_id 
    validates :store_prop_id
    validates :date
    validates :status
    validates :client
    validates :profit
    validates :valuation
  end 

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"])
      store_prop = StoreProp.find_by(phone_number_1: row["電話番号1"],name: row["店舗名"])
      errors << "#{index}行目獲得者が不正です" if user.blank? && errors.length < 5
      errors << "#{index}行目店舗名が不正です" if store_prop.blank? && errors.length < 5
      if row["ID"].present?
        rakuten_pay = find_by(id: row["ID"])
        errors << "#{index}行目 IDが不適切です" if rakuten_pay.blank? && errors.length < 5
      else  
        u_id = user.id if user.present? && errors.length < 5
        store_id = store_prop.id if store_prop.present? && errors.length < 5
        rakuten_pay = new(
          id: row["ID"],
          client: row["商流"],
          user_id: u_id,
          store_prop_id: store_id,
          share: row['上位店共有日'],
          registration: row['本登録日'],
          payment_deadline: row['入金期限'],
          payment_flag: row['入金判定'],
          date: row["獲得日"],
          status: row["審査ステータス"],
          transcript: row["謄本取得"],
          customer_num: row["申込番号"],
          deficiency: row["不備発生日"],
          deficiency_solution: row["不備解消日"],
          deficiency_info: row["情報不備詳細"],
          deficiency_consent: row["同意書不備詳細"],
          result_point: row["審査完了日"],
          payment: row["入金日"],
          profit: row["実売"],
          valuation: row["評価売"],
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if rakuten_pay.invalid? && errors.length < 5
      end
    end
    errors
  end

  def self.import(file)
    new_cnt = 0
    update_cnt = 0
    nochange_cnt = 0
    CSV.foreach(file.path, headers: true) do |row|
      user = User.find_by(name: row["獲得者"])
      store_prop = StoreProp.find_by(phone_number_1: row["電話番号1"],name: row["店舗名"])
      u_id = user.id if user.present?
      store_id = store_prop.id if store_prop.present?
      rakuten_pay = find_by(store_prop_id: store_prop.id)
      if store_prop.rakuten_pay.present?
        rakuten_pay.assign_attributes(
          client: row["商流"],
          user_id: u_id,
          store_prop_id: store_id,
          share: row['上位店共有日'],
          registration: row['本登録日'],
          payment_deadline: row['入金期限'],
          payment_flag: row['入金判定'],
          date: row["獲得日"],
          status: row["審査ステータス"],
          transcript: row["謄本取得"],
          customer_num: row["申込番号"],
          deficiency: row["不備発生日"],
          deficiency_solution: row["不備解消日"],
          deficiency_info: row["情報不備詳細"],
          deficiency_consent: row["同意書不備詳細"],
          result_point: row["審査完了日"],
          payment: row["入金日"],
          profit: row["実売"],
          valuation: row["評価売"],
        )
        if rakuten_pay.has_changes_to_save? 
          rakuten_pay.save!
          rakuten_pay.assign_attributes(status_update: Date.today)
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        rakuten_pay = new(
          client: row["商流"],
          user_id: u_id,
          store_prop_id: store_id,
          share: row['上位店共有日'],
          registration: row['本登録日'],
          payment_deadline: row['入金期限'],
          payment_flag: row['入金判定'],
          date: row["獲得日"],
          status: row["審査ステータス"],
          transcript: row["謄本取得"],
          customer_num: row["申込番号"],
          deficiency: row["不備発生日"],
          deficiency_solution: row["不備解消日"],
          deficiency_info: row["情報不備詳細"],
          deficiency_consent: row["同意書不備詳細"],
          result_point: row["審査完了日"],
          payment: row["入金日"],
          profit: row["実売"],
          valuation: row["評価売"],
          )
        rakuten_pay.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 

end
