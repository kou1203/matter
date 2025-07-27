class DmerSenbai < ApplicationRecord
  belongs_to :user
  belongs_to :settlementer, class_name: "User" , optional: true
  belongs_to :settlementer2nd, class_name: "User" , optional: true
  has_many :payment_dmer_senbais
  has_one :dmer_memo
  with_options presence: true do 
    validates :client
    validates :industry
    validates :category
    validates :store_code
    validates :customer_num
    validates :store_name
    validates :date
    validates :user_id
    validates :status
    validates :partner_status
    validates :status_settlement
    validates :settlement_deadline
    validates :post_code
    validates :prefecture
    validates :city
    validates :address
    validates :valuation_new
    validates :valuation_settlement
    validates :valuation_second_settlement
    validates :profit
  end 

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"]) rescue ""
      errors << "#{index}行目獲得者#{row["獲得者"]}が不正です" if user.blank? && errors.length < 2
        u_id = user.id if user.present? && errors.length < 2
        settlementer = User.find_by(name: row["決済対応者"])
        settlementer_params = 
        if settlementer.present?
          settlementer.id 
        else
          row["決済対応者"]
        end
        settlementer2nd = User.find_by(name: row["2回目決済対応者"])
        settlementer2nd_params = 
        if settlementer2nd.present?
          settlementer2nd.id 
        else
          row["2回目決済対応者"]
        end
        product = new(
          client: row["商流"],
          customer_num: row["申込番号"],
          store_code: row["店舗コード"],
          industry: row["業種"],
          category: row["カテゴリー"],
          store_name: row["店舗名"],
          date: row["獲得日"],
          industry_status: row["業種チェック"],
          app_check: row["申込チェック"],
          app_check_date: row["申込チェック日"],
          dup_check: row["重複チェック"],
          enter_store: row["店舗情報入力日"],
          reg_store: row["店舗登録日"],
          status: row["審査ステータス"],
          partner_status: row["PartnerStatus"],
          result_point: row["審査完了日"],
          shipment: row["キット発送日"],
          settlement: row["初回決済日"],
          picture: row["アクセプタンスアップロード日"],
          picture_latest: row["最終アクセプタンスアップロード日"],
          picture_check: row["アクセプタンスチェック"],
          picture_check_date: row["アクセプタンスチェック日"],
          dpay_slmt_latest: row["d払い店舗直近決済日"],
          merpay_slmt_latest: row["メルペイ店舗直近決済日"],
          merpay_slmt_latest: row["メルペイ店舗直近決済日"],
          settlement_deadline: row["決済期限"],
          status_settlement: row["決済ステータス"],
          post_code: row["郵便番号"],
          prefecture: row["都道府県"],
          address: row["住所"],
          city: row["市区"],
          user_id: u_id,
          settlementer_id: settlementer_params,
          settlementer2nd_id: settlementer2nd_params,
          settlement_second:row["2回目決済日"],
          valuation_new: row["評価売_審査通過"],
          valuation_settlement: row["評価売_AC合格"],
          valuation_second_settlement: row["評価売_2回目決済"],
          profit: row["実売"],
          deficiency_remarks: row["不備内容"]
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした。入力漏れがないか確認してください。" if product.invalid? && errors.length < 2
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
      settlementer = User.find_by(name: row["決済対応者"])
      settlementer_params = 
      if settlementer.present?
        settlementer.id 
      else
        row["決済対応者"]
      end
      settlementer2nd = User.find_by(name: row["2回目決済対応者"])
      settlementer2nd_params = 
      if settlementer2nd.present?
        settlementer2nd.id 
      else
        row["2回目決済対応者"]
      end
      product = find_by(store_code: row["店舗コード"])
      if product.present?
        product.assign_attributes(
          client: row["商流"],
          customer_num: row["申込番号"],
          store_code: row["店舗コード"],
          industry: row["業種"],
          category: row["カテゴリー"],
          store_name: row["店舗名"],
          date: row["獲得日"],
          industry_status: row["業種チェック"],
          app_check: row["申込チェック"],
          app_check_date: row["申込チェック日"],
          dup_check: row["重複チェック"],
          enter_store: row["店舗情報入力日"],
          reg_store: row["店舗登録日"],
          status: row["審査ステータス"],
          partner_status: row["PartnerStatus"],
          result_point: row["審査完了日"],
          shipment: row["キット発送日"],
          settlement: row["初回決済日"],
          picture: row["アクセプタンスアップロード日"],
          picture_latest: row["最終アクセプタンスアップロード日"],
          picture_check: row["アクセプタンスチェック"],
          picture_check_date: row["アクセプタンスチェック日"],
          dpay_slmt_latest: row["d払い店舗直近決済日"],
          merpay_slmt_latest: row["メルペイ店舗直近決済日"],
          merpay_slmt_latest: row["メルペイ店舗直近決済日"],
          settlement_deadline: row["決済期限"],
          status_settlement: row["決済ステータス"],
          post_code: row["郵便番号"],
          prefecture: row["都道府県"],
          address: row["住所"],
          city: row["市区"],
          user_id: u_id,
          settlementer_id: settlementer_params,
          settlementer2nd_id: settlementer2nd_params,
          settlement_second:row["2回目決済日"],
          valuation_new: row["評価売_審査通過"],
          valuation_settlement: row["評価売_AC合格"],
          valuation_second_settlement: row["評価売_2回目決済"],
          profit: row["実売"],
          deficiency_remarks: row["不備内容"]
        )
        if product.has_changes_to_save? 
          product.save!
          product.assign_attributes(status_update: Date.today)
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        product = new(
          client: row["商流"],
          customer_num: row["申込番号"],
          store_code: row["店舗コード"],
          industry: row["業種"],
          category: row["カテゴリー"],
          store_name: row["店舗名"],
          date: row["獲得日"],
          industry_status: row["業種チェック"],
          app_check: row["申込チェック"],
          app_check_date: row["申込チェック日"],
          dup_check: row["重複チェック"],
          enter_store: row["店舗情報入力日"],
          reg_store: row["店舗登録日"],
          status: row["審査ステータス"],
          partner_status: row["PartnerStatus"],
          result_point: row["審査完了日"],
          shipment: row["キット発送日"],
          settlement: row["初回決済日"],
          picture: row["アクセプタンスアップロード日"],
          picture_latest: row["最終アクセプタンスアップロード日"],
          picture_check: row["アクセプタンスチェック"],
          picture_check_date: row["アクセプタンスチェック日"],
          dpay_slmt_latest: row["d払い店舗直近決済日"],
          merpay_slmt_latest: row["メルペイ店舗直近決済日"],
          merpay_slmt_latest: row["メルペイ店舗直近決済日"],
          settlement_deadline: row["決済期限"],
          status_settlement: row["決済ステータス"],
          post_code: row["郵便番号"],
          prefecture: row["都道府県"],
          address: row["住所"],
          city: row["市区"],
          user_id: u_id,
          settlementer_id: settlementer_params,
          settlementer2nd_id: settlementer2nd_params,
          settlement_second:row["2回目決済日"],
          valuation_new: row["評価売_審査通過"],
          valuation_settlement: row["評価売_AC合格"],
          valuation_second_settlement: row["評価売_2回目決済"],
          profit: row["実売"],
          deficiency_remarks: row["不備内容"]
          )
        product.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
