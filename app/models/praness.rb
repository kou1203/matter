class Praness < ApplicationRecord
  require 'charlock_holmes'

  belongs_to :user 
  belongs_to :stock , optional: true
  with_options presence: true do 
    validates :customer_num
    validates :store_name
    validates :date
    validates :user_id
    validates :status
  end 

  def self.csv_check(file)

    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"]) 
      errors << "#{index}行目獲得者が不正です" if user.blank? && errors.length < 5
        u_id = user.id if user.present?
        praness = new(
          customer_num: row["案件番号"],
          store_name: row["店舗名"],
          date: row["獲得日"],
          user_id: u_id,
          status: row["現状ステータス"],
          cash_status: row["口座ステータス"],
          terminal_num: row["端末管理番号"],
          remarks: row["備考"],
          sales_man_remarks: row["営業側備考"],
          terminal_status: row["端末状態"],
          ssid_1: row["SSID①"],
          pass_1: row["パスワード①"],
          ssid_2: row["SSID②"],
          pass_2: row["パスワード②"],
          cancel: row["解約キャンセル"],
          cancel_reason: row["事由"],
          ssid_pass_change: row["SSID/パス変更"],
          start: row["利用開始日"],
          payment_start: row["料金発生日"],
          first_payment: row["初回引き落とし日"],
          aplus_num: row["アプラス顧客番号"],
          cash_name: row["口座名義"],
          payment_terminal: row["決済端末"],
          not_use_reason: row["端末不可理由"],
          done: row["完了"],
          option: row["オプション"],
          mail: row["メールアドレス"],
          notice_send: row["通知書送付日"],
          def_remarks: row["不備内容"]
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if praness.invalid? && errors.length < 5
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
      u_id = user.id if user.present?
      praness = find_by(customer_num: row["案件番号"])
      if praness.present?
        praness.assign_attributes(
          customer_num: row["案件番号"],
          store_name: row["店舗名"],
          date: row["獲得日"],
          user_id: u_id,
          status: row["現状ステータス"],
          cash_status: row["口座ステータス"],
          terminal_num: row["端末管理番号"],
          remarks: row["備考"],
          sales_man_remarks: row["営業側備考"],
          terminal_status: row["端末状態"],
          ssid_1: row["SSID①"],
          pass_1: row["パスワード①"],
          ssid_2: row["SSID②"],
          pass_2: row["パスワード②"],
          cancel: row["解約キャンセル"],
          cancel_reason: row["事由"],
          ssid_pass_change: row["SSID/パス変更"],
          start: row["利用開始日"],
          payment_start: row["料金発生日"],
          first_payment: row["初回引き落とし日"],
          aplus_num: row["アプラス顧客番号"],
          cash_name: row["口座名義"],
          payment_terminal: row["決済端末"],
          not_use_reason: row["端末不可理由"],
          done: row["完了"],
          option: row["オプション"],
          mail: row["メールアドレス"],
          notice_send: row["通知書送付日"],
          def_remarks: row["不備内容"]
        )
        if praness.has_changes_to_save? 
          praness.save!
          praness.assign_attributes(status_update: Date.today)
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        praness = new(
          customer_num: row["案件番号"],
          store_name: row["店舗名"],
          date: row["獲得日"],
          user_id: u_id,
          status: row["現状ステータス"],
          cash_status: row["口座ステータス"],
          terminal_num: row["端末管理番号"],
          remarks: row["備考"],
          sales_man_remarks: row["営業側備考"],
          terminal_status: row["端末状態"],
          ssid_1: row["SSID①"],
          pass_1: row["パスワード①"],
          ssid_2: row["SSID②"],
          pass_2: row["パスワード②"],
          cancel: row["解約キャンセル"],
          cancel_reason: row["事由"],
          ssid_pass_change: row["SSID/パス変更"],
          start: row["利用開始日"],
          payment_start: row["料金発生日"],
          first_payment: row["初回引き落とし日"],
          aplus_num: row["アプラス顧客番号"],
          cash_name: row["口座名義"],
          payment_terminal: row["決済端末"],
          not_use_reason: row["端末不可理由"],
          done: row["完了"],
          option: row["オプション"],
          mail: row["メールアドレス"],
          notice_send: row["通知書送付日"],
          def_remarks: row["不備内容"]
          )
        praness.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 

end
