class NuroManagemenetFee < ApplicationRecord
  with_options presence: true do 
    validates :service
    validates :fee_len
    validates :price
    validates :date
    validates :payment
  end 


  def self.csv_check(file)

    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      errors << "#{index}行目獲得者が不正です" if user.blank? && errors.length < 5
      nuro_management_fee = new(
          service: row["サービス名"],
          fee_len: row["件数"],
          price: row["手数料"],
          date: row["申込日"],
          payment: row["入金日"]
        )
        errors << "#{index}行目が保存できませんでした" if nuro_management_fee.invalid? && errors.length < 5
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
      nuro_management_fee = find_by(date: row["申込日"],payment: row["入金日"],service: row["サービス名"])
      if nuro_management_fee.present?
        nuro_management_fee.assign_attributes(
          service: row["サービス名"],
          fee_len: row["件数"],
          price: row["手数料"],
          date: row["申込日"],
          payment: row["入金日"]
        )
        if nuro_management_fee.has_changes_to_save? 
          nuro_management_fee.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        nuro_management_fee = new(
          service: row["サービス名"],
          fee_len: row["件数"],
          price: row["手数料"],
          date: row["申込日"],
          payment: row["入金日"]
          )
          nuro_management_fee.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
end
