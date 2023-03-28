class Paypay < ApplicationRecord
  require 'charlock_holmes'

  belongs_to :store_prop
  belongs_to :user
  has_one :payment_paypay

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
        u_id = user.id if user.present?
        store_id = store_prop.id if store_prop.present?
        paypay = new(
          # id: row["ID"],
          customer_num: row["上位店管理番号"],
          client: row["商流"],
          user_id: u_id,
          store_prop_id: store_id,
          date: row["獲得日"],
          status: row["審査ステータス"],
          status_update: row["ステータス更新日"],
          deficiency: row["不備発生日"],
          deficiency_solution: row["不備解消日"],
          payment: row["入金日"],
          remarks: row["備考"],
          result_point: row["審査完了日"],
          profit: row["実売"],
          valuation: row["評価売"],
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if paypay.invalid? && errors.length < 5
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
      user = User.find_by(name: row["獲得者"])
      store_prop = StoreProp.find_by(phone_number_1: row["電話番号1"],name: row["店舗名"])
      u_id = user.id if user.present?
      store_id = store_prop.id if store_prop.present?
      paypay = find_by(store_prop_id: store_prop.id)
      if store_prop.paypay.present? && Paypay.find_by(customer_num: row["上位店管理番号"]).present?
        paypay.assign_attributes(
          customer_num: row["上位店管理番号"],
          client: row["商流"],
          user_id: u_id,
          store_prop_id: store_id,
          date: row["獲得日"],
          status: row["審査ステータス"],
          deficiency: row["不備発生日"],
          deficiency_solution: row["不備解消日"],
          payment: row["入金日"],
          remarks: row["備考"],
          result_point: row["審査完了日"],
          profit: row["実売"],
          valuation: row["評価売"],
        )
        if paypay.has_changes_to_save? 
          paypay.save!
          paypay.assign_attributes(status_update: Date.today)
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        paypay = new(
          id: row["ID"],
          customer_num: row["上位店管理番号"],
          client: row["商流"],
          user_id: u_id,
          store_prop_id: store_id,
          date: row["獲得日"],
          status: row["審査ステータス"],
          status_update: Date.today,
          deficiency: row["不備発生日"],
          deficiency_solution: row["不備解消日"],
          payment: row["入金日"],
          remarks: row["備考"],
          result_point: row["審査完了日"],
          profit: row["実売"],
          valuation: row["評価売"],
          )
        paypay.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 

end
