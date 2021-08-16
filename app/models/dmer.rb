class Dmer < ApplicationRecord
  belongs_to :user
  belongs_to :settlementer, class_name: "User" , optional: true
  belongs_to :store_prop

  with_options presence: true do 
    validates :customer_num
    validates :client
    validates :user_id 
    validates :store_prop_id 
    validates :date
    validates :status 
    validates :status_settlement 
    validates :profit_new
    validates :profit_settlement
    validates :valuation_new
    validates :valuation_settlement
  end 


  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"])
      store_prop = StoreProp.find_by(name: row["店舗名"])
      settlementer = User.find_by(name: row["決済対応者"])
      settlementer_params = 
      if settlementer.present?
        settlementer.id 
      else
        row["決済対応者"]
      end
      errors << "#{index}行目獲得者が不正です" if user.blank?
      errors << "#{index}行目店舗名が不正です" if store_prop.blank?
      if row["ID"].present?
        dmer = find_by(id: row["ID"])
        errors << "#{index}行目 IDが不適切です" if dmer.blank?
      else  
        u_id = user.id if user.present?
        store_id = store_prop.id if store_prop.present?
        dmer = new(
          id: row["ID"],
          customer_num: row["お申込み番号"],
          client: row["商流"],
          user_id: u_id,
          store_prop_id: store_id,
          date: row["獲得日"],
          status: row["審査ステータス"],
          status_update: row["ステータス更新日"],
          settlementer_id: settlementer_params,
          settlement: row["初回決済発生日"],
          settlement_deadline: row["決済期限"],
          status_settlement: row["決済ステータス"],
          status_update_settlement: row["決済ステータス更新日"],
          payment: row["入金日"],
          payment_settlement: row["決済入金日"],
          profit_new: row["獲得売上"],
          profit_settlement: row["決済売上"],
          valuation_new: row["獲得評価売上"],
          valuation_settlement: row["決済評価売上"],
          description: row["備考"]
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if dmer.invalid?
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
      store_prop = StoreProp.find_by(name: row["店舗名"])
      settlementer = User.find_by(name: row["決済対応者"])
      settlementer_params = 
      if settlementer.present?
        settlementer.id 
      else
        row["決済対応者"]
      end

      dmer = find_by(store_prop_id:  store_prop.id)
      if store_prop.dmer.present? && Dmer.find_by(customer_num: row["お申込み番号"]).present? 
        dmer.assign_attributes(
          customer_num: row["お申込み番号"],
          client: row["商流"],
          user_id: user.id,
          store_prop_id: store_prop.id,
          date: row["獲得日"],
          status: row["審査ステータス"],
          status_update: row["ステータス更新日"],
          settlementer_id: settlementer_params,
          settlement: row["初回決済発生日"],
          settlement_deadline: row["決済期限"],
          status_settlement: row["決済ステータス"],
          status_update_settlement: row["決済ステータス更新日"],
          payment: row["入金日"],
          payment_settlement: row["決済入金日"],
          profit_new: row["獲得売上"],
          profit_settlement: row["決済売上"],
          valuation_new: row["獲得評価売上"],
          valuation_settlement: row["決済評価売上"],
          description: row["備考"]
        )
        if dmer.has_changes_to_save? 
          dmer.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        dmer = new(
          id: row["ID"],
          customer_num: row["お申込み番号"],
          client: row["商流"],
          user_id: user.id,
          store_prop_id: store_prop.id,
          date: row["獲得日"],
          status: row["審査ステータス"],
          status_update: row["ステータス更新日"],
          settlementer_id: settlementer_params,
          settlement: row["初回決済発生日"],
          settlement_deadline: row["決済期限"],
          status_settlement: row["決済ステータス"],
          status_update_settlement: row["決済ステータス更新日"],
          payment: row["入金日"],
          payment_settlement: row["決済入金日"],
          profit_new: row["獲得売上"],
          profit_settlement: row["決済売上"],
          valuation_new: row["獲得評価売上"],
          valuation_settlement: row["決済評価売上"],
          description: row["備考"]
          )
        dmer.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 

end
    
  
  # def self.updatable_attributes
  #   [
  #     "customer_num",
  #     "client",
  #     "user_id",
  #     "store_prop_id",
  #     "date",
  #     "status",
  #     "status_update",
  #     "settlementer_id",
  #     "settlement",
  #     "settlement_deadline",
  #     "status_settlement",
  #     "status_update_settlement",
  #     "payment",
  #     "payment_settlement",
  #     "profit_new",
  #     "profit_settlement",
  #     "valuation_new",
  #     "valuation_settlement",
  #     "description",
  #   ]
  # end
