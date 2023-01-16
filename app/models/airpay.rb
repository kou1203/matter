class Airpay < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :user 
  belongs_to :store_prop 

  with_options presence: true do 
    validates :user_id
    validates :store_prop_id
    validates :date 
    validates :status
    validates :customer_num
    validates :valuation
    validates :profit
  end 

  # データが問題ないかチェックする関数
  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      airpay_store = Airpay.find_by(customer_num: row["店舗番号"]) 
      user = User.find_by(name: row["獲得者"])
      store_prop = StoreProp.find_by(phone_number_1: row["電話番号1"],name: row["店舗名"])
      if airpay_store.present?
        store_id = airpay_store.store_prop_id if airpay_store.present?
      else
        store_id = store_prop.id if store_prop.present? 
      end 
      errors << "#{index}行目獲得者#{row["獲得者"]}が不正です" if user.blank? && errors.length < 5
      errors << "#{index}行目店舗名が不正です" if store_id.blank? && errors.length < 5
        airpay = new(
          store_prop_id: store_id,
          user_id: user.id,
          date: row["申込日"],
          client: row["商流"],
          terminal_status: row["端末ステータス"],
          status: row["審査状況"],
          customer_num: row["店舗番号"],
          customer_conf: row["お申込者様に関する確認"],
          slmt_conf: row["決済を行う店舗に関する確認"],
          cash_conf: row["口座情報に関する確認"],
          doubt_remarks: row["疑出し内容"],
          result_point: row["審査通過日"],
          qr_flag: row["QR同時申込有無"],
          ipad_flag: row["iPadCPN申込有無"],
          doc_follow: row["書類フォロー"],
          doc_deadline: row["書類提出期限"],
          shipping: row["端末受取日"],
          delivery_status: row["端末受取状態"],
          activate: row["アクティベート日"],
          profit: 3000,
          valuation: 3000,
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if airpay.invalid? && errors.length < 5
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
    store_id = store_prop.id if store_prop.present? 
    airpay = find_by(customer_num: row["店舗番号"])
    if airpay.present? 
      airpay.assign_attributes(
        store_prop_id: store_id,
        user_id: user.id,
        date: row["申込日"],
        client: row["商流"],
        terminal_status: row["端末ステータス"],
        status: row["審査状況"],
        customer_num: row["店舗番号"],
        customer_conf: row["お申込者様に関する確認"],
        slmt_conf: row["決済を行う店舗に関する確認"],
        cash_conf: row["口座情報に関する確認"],
        doubt_remarks: row["疑出し内容"],
        result_point: row["審査通過日"],
        qr_flag: row["QR同時申込有無"],
        ipad_flag: row["iPadCPN申込有無"],
        doc_follow: row["書類フォロー"],
        doc_deadline: row["書類提出期限"],
        shipping: row["端末受取日"],
        delivery_status: row["端末受取状態"],
        activate: row["アクティベート日"],
        profit: 3000,
        valuation: 3000,
      )
      if airpay.has_changes_to_save? 
        airpay.save!
        airpay.assign_attributes(status_update: Date.today)
        update_cnt += 1
      else  
        nochange_cnt += 1
      end 
    else  
      airpay = new(
        store_prop_id: store_id,
        user_id: user.id,
        date: row["申込日"],
        client: row["商流"],
        terminal_status: row["端末ステータス"],
        status: row["審査状況"],
        customer_num: row["店舗番号"],
        customer_conf: row["お申込者様に関する確認"],
        slmt_conf: row["決済を行う店舗に関する確認"],
        cash_conf: row["口座情報に関する確認"],
        doubt_remarks: row["疑出し内容"],
        result_point: row["審査通過日"],
        qr_flag: row["QR同時申込有無"],
        ipad_flag: row["iPadCPN申込有無"],
        doc_follow: row["書類フォロー"],
        doc_deadline: row["書類提出期限"],
        shipping: row["端末受取日"],
        delivery_status: row["端末受取状態"],
        activate: row["アクティベート日"],
        profit: 3000,
        valuation: 3000,
        )
      airpay.save!
      new_cnt += 1
    end
  end
  "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件 "
  end
end
