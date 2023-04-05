class PaymentItss < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :itss , optional: true
  with_options presence: true do 
    validates :payment
  end 

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
        product = new(
          entry_date: row["ET"],
          controll_num: row["管理番号"],
          p_num: row["P番号"],
          customer_name: row["顧客名"],
          price: row["手数料"],
          company: row["会社名"],
          client: row["商流"],
          payment: row["入金日"],
        )
        errors << "#{index}行目,顧客名「#{row["顧客名"]}」保存できませんでした" if product.invalid? && errors.length < 5
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
      product = find_by(controll_num: row["管理番号"])
      p_id = Itss.find_by(customer_num: row["管理番号"]).id rescue ""
      if product.present?
        product.assign_attributes(
          itss_id: p_id,
          entry_date: row["ET"],
          controll_num: row["管理番号"],
          p_num: row["P番号"],
          customer_name: row["顧客名"],
          price: row["手数料"],
          company: row["会社名"],
          client: row["商流"],
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
          itss_id: p_id,
          entry_date: row["ET"],
          controll_num: row["管理番号"],
          p_num: row["P番号"],
          customer_name: row["顧客名"],
          price: row["手数料"],
          company: row["会社名"],
          client: row["商流"],
          payment: row["入金日"],
          )
          product.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
