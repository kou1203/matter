class PaymentAirpay < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :airpay , optional: true
  with_options presence: true do 
    validates :payment
  end


  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
        product = new(
          controll_num: row["管理番号"],
          akr_num: row["AKR番号"],
          store_name: row["店舗名"],
          date: row["申込日"],
          result_point: row["契約完了日"],
          result_category: row["種別"],
          payment: row["入金日"],
          price: row["金額"],
          client: row["商流"],
          company: row["会社名"],
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
      product = find_by(akr_num: row["AKR番号"],result_category: row["種別"])
      air_id = Airpay.find_by(customer_num: row["AKR番号"]).id rescue ""
      if product.present?
        product.assign_attributes(
          airpay_id: air_id,
          controll_num: row["管理番号"],
          akr_num: row["AKR番号"],
          store_name: row["店舗名"],
          date: row["申込日"],
          result_point: row["契約完了日"],
          result_category: row["種別"],
          payment: row["入金日"],
          price: row["金額"],
          client: row["商流"],
          company: row["会社名"],
        )
        if product.has_changes_to_save? 
          product.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        product = new(
          airpay_id: air_id,
          controll_num: row["管理番号"],
          akr_num: row["AKR番号"],
          store_name: row["店舗名"],
          date: row["申込日"],
          result_point: row["契約完了日"],
          result_category: row["種別"],
          payment: row["入金日"],
          price: row["金額"],
          client: row["商流"],
          company: row["会社名"],
          )
          product.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
