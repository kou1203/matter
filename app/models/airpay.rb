class Airpay < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :user 

  with_options presence: true do 
    validates :user_id
    validates :store_name
    validates :date 
    validates :status
    validates :customer_num
    validates :kr_code
    validates :ipad_flag
    validates :vm_status
    validates :vm_status_name
    validates :valuation
    validates :profit
  end 

  # データが問題ないかチェックする関数
  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"])
      errors << "#{index}行目獲得者が不正です" if user.blank? && errors.length < 5
        airpay = new(
          status: row["審査ステータス"],
          terminal_status: row["端末ステータス"],
          user_id: user.id,
          date: row["申込日"],
          corporate_name: row["法人名"],
          store_name: row["店舗名"],
          customer_num: row["店舗番号"],
          result_point: row["V/M契約完了日"],
          vm_status: row["VM審査ステータス"],
          vm_status_name: row["VM審査ステータス_名称"],
          ipad_flag: row["iPad申込区分"],
          kr_code: row["KRコード"],
          doc_follow: row["書類フォロー"],
          shipping: row["出荷処理日"],
          delivery_status: row["配送ST"],
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
    airpay = find_by(customer_num: row["店舗番号"])
    if airpay.present? 
      airpay.assign_attributes(
        status: row["審査ステータス"],
        terminal_status: row["端末ステータス"],
        user_id: user.id,
        date: row["申込日"],
        corporate_name: row["法人名"],
        store_name: row["店舗名"],
        customer_num: row["店舗番号"],
        result_point: row["V/M契約完了日"],
        vm_status: row["VM審査ステータス"],
        vm_status_name: row["VM審査ステータス_名称"],
        ipad_flag: row["iPad申込区分"],
        kr_code: row["KRコード"],
        doc_follow: row["書類フォロー"],
        shipping: row["出荷処理日"],
        delivery_status: row["配送ST"],
        activate: row["アクティベート日"],
        profit: 3000,
        valuation: 3000,
      )
      if airpay.has_changes_to_save? 
        airpay.save!
        update_cnt += 1
      else  
        nochange_cnt += 1
      end 
    else  
      airpay = new(
        status: row["審査ステータス"],
        terminal_status: row["端末ステータス"],
        user_id: user.id,
        date: row["申込日"],
        corporate_name: row["法人名"],
        store_name: row["店舗名"],
        customer_num: row["店舗番号"],
        result_point: row["V/M契約完了日"],
        vm_status: row["VM審査ステータス"],
        vm_status_name: row["VM審査ステータス_名称"],
        ipad_flag: row["iPad申込区分"],
        kr_code: row["KRコード"],
        doc_follow: row["書類フォロー"],
        shipping: row["出荷処理日"],
        delivery_status: row["配送ST"],
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
