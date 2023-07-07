class PranessOption < ApplicationRecord
  require 'charlock_holmes'

  belongs_to :user
  belongs_to :praness, optional: true

  with_options presence: true do 
    validates :customer_num
    validates :store_name
    validates :user_id
    validates :date
    validates :price
    validates :price_tax
    validates :payment_date
    validates :status
  end 



  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"]) rescue ""
      errors << "#{index}行目獲得者が不正です" if user.blank? && errors.length < 5
        u_id = user.id if user.present?
      praness = Praness.find_by(aplus_num: row["アプラス顧客番号"]) rescue ""
      p_id = praness.id if praness.present?
        product = new(
          customer_num: row["顧客番号"],
          store_name: row["店舗名"],
          date: row["獲得日"],
          user_id: u_id,
          cancel: row["解約日"],
          start: row["料金発生日"],
          praness_id: p_id,
          option_customer_num: row["オプション用顧客番号"],
          price: row["単価（税込）"],
          price_tax: row["単価（税抜）"],
          payment_date: row["売上月"],
          status: row["支払状況"],
          payment_method: row["請求方法"],
          payment_schedule: row["入金/振替予定日"],
          payment: row["実入金/振替日"],
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if product.invalid? && errors.length < 5
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
      praness = Praness.find_by(aplus_num: row["アプラス顧客番号"])
      p_id = praness.id if praness.present?
      product = PranessOption.find_by(customer_num: row["顧客番号"],payment_date: row["売上月"])
      if product.present?
        product.assign_attributes(
          customer_num: row["顧客番号"],
          store_name: row["店舗名"],
          date: row["獲得日"],
          user_id: u_id,
          cancel: row["解約日"],
          start: row["料金発生日"],
          praness_id: p_id,
          option_customer_num: row["オプション用顧客番号"],
          price: row["単価（税込）"],
          price_tax: row["単価（税抜）"],
          payment_date: row["売上月"],
          status: row["支払状況"],
          payment_method: row["請求方法"],
          payment_schedule: row["入金/振替予定日"],
          payment: row["実入金/振替日"],
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
          customer_num: row["顧客番号"],
          store_name: row["店舗名"],
          date: row["獲得日"],
          user_id: u_id,
          cancel: row["解約日"],
          start: row["料金発生日"],
          praness_id: p_id,
          option_customer_num: row["オプション用顧客番号"],
          price: row["単価（税込）"],
          price_tax: row["単価（税抜）"],
          payment_date: row["売上月"],
          status: row["支払状況"],
          payment_method: row["請求方法"],
          payment_schedule: row["入金/振替予定日"],
          payment: row["実入金/振替日"],
          )
        product.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 

end
