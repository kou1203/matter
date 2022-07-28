class Airpay < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :user 

  with_options presence: true do 
    validates :user_id
    validates :store_name
    validates :date 
    validates :status
    validates :customer_num
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
          status: row["審査状況"],
          terminal_status: row["端末ステータス"],
          user_id: user.id,
          date: row["申込日"],
          corporate_name: row["法人名"],
          store_name: row["店舗名"],
          customer_num: row["店舗番号"],
          result_point: row["審査通過日"],
          vm_status: row["審査ステータス"],
          vm_status_name: row["審査ステータス読替"],
          ipad_flag: row["iPadCPN申込有無"],
          doc_follow: row["書類フォロー"],
          shipping: row["端末受取日"],
          delivery_status: row["端末受取状態"],
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
        status: row["審査状況"],
        terminal_status: row["端末ステータス"],
        user_id: user.id,
        date: row["申込日"],
        corporate_name: row["法人名"],
        store_name: row["店舗名"],
        customer_num: row["店舗番号"],
        result_point: row["審査通過日"],
        vm_status: row["審査ステータス"],
        vm_status_name: row["審査ステータス読替"],
        ipad_flag: row["iPadCPN申込有無"],
        doc_follow: row["書類フォロー"],
        shipping: row["端末受取日"],
        delivery_status: row["端末受取状態"],
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
        status: row["審査状況"],
        terminal_status: row["端末ステータス"],
        user_id: user.id,
        date: row["申込日"],
        corporate_name: row["法人名"],
        store_name: row["店舗名"],
        customer_num: row["店舗番号"],
        result_point: row["審査通過日"],
        vm_status: row["審査ステータス"],
        vm_status_name: row["審査ステータス読替"],
        ipad_flag: row["iPadCPN申込有無"],
        doc_follow: row["書類フォロー"],
        shipping: row["端末受取日"],
        delivery_status: row["端末受取状態"],
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
