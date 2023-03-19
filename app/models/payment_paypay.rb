class PaymentPaypay < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :paypay , optional: true
  with_options presence: true do 
    validates :payment
  end


  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
        product = new(
          controll_num: row["管理コード"],
          store_name: row["法人名、屋号名"],
          date: row["申込完了日"],
          result_point: row["審査可決日"],
          result_category: row["手数料名称"],
          payment: row["入金日"],
          price: row["手数料金額"],
          client: row["商流"],
          company: row["企業名"],
        )
        errors << "#{index}行目,店舗名「#{row["法人名、屋号名"]}」保存できませんでした" if product.invalid? && errors.length < 5
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
      product = find_by(controll_num: row["管理コード"],result_category: row["手数料名称"])
      p_id = Paypay.find_by(customer_num: row["管理コード"]).id rescue ""
      if product.present?
        product.assign_attributes(
          paypay_id: p_id,
          controll_num: row["管理コード"],
          store_name: row["法人名、屋号名"],
          date: row["申込完了日"],
          result_point: row["審査可決日"],
          result_category: row["手数料名称"],
          payment: row["入金日"],
          price: row["手数料金額"],
          client: row["商流"],
          company: row["企業名"],
        )
        if product.has_changes_to_save? 
          product.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        product = new(
          paypay_id: p_id,
          controll_num: row["管理コード"],
          store_name: row["法人名、屋号名"],
          date: row["申込完了日"],
          result_point: row["審査可決日"],
          result_category: row["手数料名称"],
          payment: row["入金日"],
          price: row["手数料金額"],
          client: row["商流"],
          company: row["企業名"],
          )
          product.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
