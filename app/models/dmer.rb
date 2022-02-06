class Dmer < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :user
  belongs_to :settlementer, class_name: "User" , optional: true
  belongs_to :store_prop

  with_options presence: true do 
    validates :client
    validates :user_id 
    validates :store_prop_id 
    validates :date
    validates :status 
    validates :profit_new
    validates :profit_settlement
    validates :valuation_new
    validates :valuation_settlement
  end 


  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"])
      store_prop = StoreProp.find_by(phone_number_1: row["電話番号1"],name: row["店舗名"])
      settlementer = User.find_by(name: row["決済対応者"])
      settlementer_params = 
      if settlementer.present?
        settlementer.id 
      else
        row["決済対応者"]
      end
      errors << "#{index}行目獲得者が不正です" if user.blank? && errors.length < 5
      errors << "#{index}行目店舗名が不正です" if store_prop.blank? && errors.length < 5
        u_id = user.id if user.present?
        store_id = store_prop.id if store_prop.present?
        dmer = new(
          # id: row["ID"],
          customer_num: row["お申込み番号"],
          client: row["商流"],
          user_id: u_id,
          store_prop_id: store_id,
          date: row["獲得日"],
          industry_status: row["業種評価"],
          status: row["審査ステータス"],
          share: row["上位点共有日"],
          shipment: row["キット発送日"],
          settlementer_id: settlementer_params,
          settlement: row["初回決済発生日"],
          settlement_second: row["２回目決済発生日"],
          picture: row["アクセプタンスアップロード日"],
          settlement_deadline: row["決済期限"],
          status_settlement: row["決済ステータス"],
          status_update_settlement: row["決済ステータス更新日"],
          payment: row["入金日"],
          payment_settlement: row["決済入金日"],
          result_point: row["審査完了日（新規）"],
          result_point_settlement: row["審査完了日（決済）"],
          deficiency: row["不備発生日（新規）"],
          deficiency_settlement: row["不備発生日（決済）"],
          deficiency_solution: row["不備解消日（新規）"],
          deficiency_solution_settlement: row["不備解消日（決済）"],
          deficiency_deadline: row["不備解消期限"],
          deficiency_remarks: row["不備詳細（新規）"],
          deficiency_remarks_settlement: row["不備詳細（決済）"],
          description: row["備考"],
          profit_new: row["獲得実売"],
          profit_settlement: row["決済実売"],
          valuation_new: row["獲得評価売"],
          valuation_settlement: row["決済評価売"],
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if dmer.invalid? && errors.length < 5
    end
    errors
  end

  def self.import(file)
    detection = CharlockHolmes::EncodingDetector.detect(File.read(file.path))
    encoding = detection[:encoding] == 'Shift_JIS' ? 'CP932' : detection[:encoding]
    new_cnt = 0
    update_cnt = 0
    nochange_cnt = 0
    update_message = []
    CSV.foreach(file.path, encoding: "#{encoding}:UTF-8",headers: true) do |row|
      user = User.find_by(name: row["獲得者"])
      store_prop = StoreProp.find_by(phone_number_1: row["電話番号1"],name: row["店舗名"])
      settlementer = User.find_by(name: row["決済対応者"])
      settlementer_params = 
      if settlementer.present?
        settlementer.id 
      else
        row["決済対応者"]
      end

      dmer = find_by(store_prop_id:  store_prop.id)
      if store_prop.dmer.present?
        dmer.assign_attributes(
          customer_num: row["お申込み番号"],
          client: row["商流"],
          user_id: user.id,
          store_prop_id: store_prop.id,
          date: row["獲得日"],
          industry_status: row["業種評価"],
          status: row["審査ステータス"],
          share: row["上位点共有日"],
          shipment: row["キット発送日"],
          settlementer_id: settlementer_params,
          settlement_deadline: row["決済期限"],
          settlement: row["初回決済発生日"],
          settlement_second: row["２回目決済発生日"],
          picture: row["アクセプタンスアップロード日"],
          settlement_deadline: row["決済期限"],
          status_settlement: row["決済ステータス"],
          payment: row["入金日"],
          payment_settlement: row["決済入金日"],
          result_point: row["審査完了日（新規）"],
          result_point_settlement: row["審査完了日（決済）"],
          deficiency: row["不備発生日（新規）"],
          deficiency_settlement: row["不備発生日（決済）"],
          deficiency_solution: row["不備解消日（新規）"],
          deficiency_solution_settlement: row["不備解消日（決済）"],
          deficiency_deadline: row["不備解消期限"],
          deficiency_remarks: row["不備詳細（新規）"],
          deficiency_remarks_settlement: row["不備詳細（決済）"],
          description: row["備考"],
          profit_new: row["獲得実売"],
          profit_settlement: row["決済実売"],
          valuation_new: row["獲得評価売"],
          valuation_settlement: row["決済評価売"],
        )
        if dmer.has_changes_to_save? 
          dmer.save!
          dmer.assign_attributes(status_update: Date.today)
          update_message << "#{store_prop.name}の情報を更新しました！" if update_message.length < 10
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        dmer = new(
          customer_num: row["お申込み番号"],
          client: row["商流"],
          user_id: user.id,
          store_prop_id: store_prop.id,
          date: row["獲得日"],
          industry_status: row["業種評価"],
          status: row["審査ステータス"],
          status_update: Date.today,
          share: row["上位点共有日"],
          shipment: row["キット発送日"],
          settlementer_id: settlementer_params,
          settlement: row["初回決済発生日"],
          settlement_second: row["２回目決済発生日"],
          picture: row["アクセプタンスアップロード日"],
          settlement_deadline: row["決済期限"],
          status_settlement: row["決済ステータス"],
          status_update_settlement: row["決済ステータス更新日"],
          payment: row["入金日"],
          payment_settlement: row["決済入金日"],
          result_point: row["審査完了日（新規）"],
          result_point_settlement: row["審査完了日（決済）"],
          deficiency: row["不備発生日（新規）"],
          deficiency_settlement: row["不備発生日（決済）"],
          deficiency_solution: row["不備解消日（新規）"],
          deficiency_solution_settlement: row["不備解消日（決済）"],
          deficiency_deadline: row["不備解消期限"],
          deficiency_remarks: row["不備詳細（新規）"],
          deficiency_remarks_settlement: row["不備詳細（決済）"],
          description: row["備考"],
          profit_new: row["獲得実売"],
          profit_settlement: row["決済実売"],
          valuation_new: row["獲得評価売"],
          valuation_settlement: row["決済評価売"],
          )
        dmer.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件,#{update_message}"
  end 
end
