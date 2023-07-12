class PaymentPraness < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :praness

  with_options presence: true do 
    validates :praness_id
    validates :store_name
    validates :status
  end 


  def self.csv_check(file)

    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      praness = Praness.find_by(customer_num: row["案件番号"]) 
      errors << "#{index}行目案件番号が不正です" if praness.blank? && errors.length < 5
        p_id = praness.id if praness.present?
        product = new(
          store_name: row["店舗名"],
          praness_id: p_id,
          aplus_customer_num: row["アプラス顧客番号"],
          price: row["単価（税抜）"],
          price_tax: row["単価（税込）"],
          payment_date: row["売上月_日付型"],
          status: row["支払状況"],
          payment_method: row["請求方法"],
          payment_schedule: row["入金/振替予定日"],
          payment: row["実入金/振替日"],
          remarks: row["備考2"],
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
      praness = Praness.find_by(customer_num: row["案件番号"])
      p_id = praness.id if praness.present?
      product = find_by(praness_id: p_id,payment_date: row["売上月_日付型"])
      if product.present?
        product.assign_attributes(
          store_name: row["店舗名"],
          praness_id: p_id,
          aplus_customer_num: row["アプラス顧客番号"],
          price: row["単価（税抜）"],
          price_tax: row["単価（税込）"],
          payment_date: row["売上月_日付型"],
          status: row["支払状況"],
          payment_method: row["請求方法"],
          payment_schedule: row["入金/振替予定日"],
          payment: row["実入金/振替日"],
          remarks: row["備考2"],
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
          store_name: row["店舗名"],
          praness_id: p_id,
          aplus_customer_num: row["アプラス顧客番号"],
          price: row["単価（税抜）"],
          price_tax: row["単価（税込）"],
          payment_date: row["売上月_日付型"],
          status: row["支払状況"],
          payment_method: row["請求方法"],
          payment_schedule: row["入金/振替予定日"],
          payment: row["実入金/振替日"],
          remarks: row["備考2"],
          )
        product.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 

end
