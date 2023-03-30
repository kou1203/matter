class PaymentAupay < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :aupay , optional: true
  with_options presence: true do 
    validates :payment
  end


  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
        product = new(
          record_num: row["レコードNO."],
          store_name: row["au PAY 店舗名"],
          result_point: row["審査通過日"],
          client: row["商流"],
          result_category: "決済手数料",
          price: row["初回決済時手数料"],
          payment: row["入金日"],
        )
        errors << "#{index}行目,店舗名「#{row["au PAY 店舗名"]}」保存できませんでした" if product.invalid? && errors.length < 5
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
      product = find_by(record_num: row["レコードNO."])
      a_id = Aupay.find_by(record_num: row["レコードNO."]).id rescue ""
      if product.present?
        product.assign_attributes(
          aupay_id: a_id,
          record_num: row["レコードNO."],
          store_name: row["au PAY 店舗名"],
          result_point: row["審査通過日"],
          client: row["商流"],
          result_category: "決済手数料",
          price: row["初回決済時手数料"],
          payment: row["入金日"],
        )
        if product.has_changes_to_save? 
          product.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        product = new(
          aupay_id: a_id,
          record_num: row["レコードNO."],
          store_name: row["au PAY 店舗名"],
          result_point: row["審査通過日"],
          client: row["商流"],
          result_category: "決済手数料",
          price: row["初回決済時手数料"],
          payment: row["入金日"],
          )
          product.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
