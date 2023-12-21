class PaymentDmerSenbai < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :dmer_senbai , optional: true

  with_options presence: true do 
    validates :client
    validates :store_code
    validates :payment
    validates :price
  end 

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
        product = new(
          client: row["商流"],
          store_code: row["店舗コード"],
          customer_num: row["申込番号"],
          store_name: row["店舗名"],
          date: row["申込日"],
          payment: row["入金日"],
          price: row["単価"]
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
      product = find_by(store_code: row["店舗コード"])
      p_id = DmerSenbai.find_by(store_code: row["店舗コード"]).id rescue ""
      if product.present?
        product.assign_attributes(
          dmer_senbai_id: p_id,
          client: row["商流"],
          store_code: row["店舗コード"],
          customer_num: row["申込番号"],
          store_name: row["店舗名"],
          date: row["申込日"],
          payment: row["入金日"],
          price: row["単価"]
        )
        if product.has_changes_to_save? 
          product.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        product = new(
          dmer_senbai_id: p_id,
          client: row["商流"],
          store_code: row["店舗コード"],
          customer_num: row["申込番号"],
          store_name: row["店舗名"],
          date: row["申込日"],
          payment: row["入金日"],
          price: row["単価"]
          )
          product.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
