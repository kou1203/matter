class StInsurance < ApplicationRecord

  with_options presence: true do 
    validates :user_id 
    validates :store_prop_id
    validates :date
    validates :status
    validates :client
    validates :profit
    validates :valuation
  end 

  belongs_to :store_prop
  belongs_to :user

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"])
      store_prop = StoreProp.find_by(name: row["店舗名"])
      errors << "#{index}行目獲得者が不正です" if user.blank?
      errors << "#{index}行目店舗名が不正です" if store_prop.blank?
      if row["ID"].present?
        st_insurance = find_by(id: row["ID"])
        errors << "#{index}行目 IDが不適切です" if st_insurance.blank?
      else  
        u_id = user.id if user.present?
        store_id = store_prop.id if store_prop.present?
        st_insurance = new(
          id: row["ID"],
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
          result_point: row["上位店連携日"],
          profit: row["実売上"],
          valuation: row["評価売上"],
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if st_insurance.invalid?
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
      u_id = user.id if user.present?
      store_id = store_prop.id if store_prop.present?
      st_insurance = find_by(store_prop_id:  store_prop.id)
      if store_prop.st_insurance.present? 
        st_insurance.assign_attributes(
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
          result_point: row["上位店連携日"],
          profit: row["実売上"],
          valuation: row["評価売上"],
        )
        if st_insurance.has_changes_to_save? 
          st_insurance.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        st_insurance = new(
          id: row["ID"],
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
          result_point: row["上位店連携日"],
          profit: row["実売上"],
          valuation: row["評価売上"],
          )
        st_insurance.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
