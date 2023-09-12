class NuroPayment < ApplicationRecord
  belongs_to :nuro
  with_options presence: true do 
    validates :nuro_id
    validates :category
    validates :isp_num
    validates :name   
    validates :service
    validates :payment  
    validates :price
  end 


  def self.csv_check(file)

    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      nuro = Nuro.find_by(isp_num: row["ISP契約番号"]) 
      errors << "#{index}行目獲得者が不正です" if user.blank? && errors.length < 5
        n_id = nuro.id if nuro.present?
        nuro = new(
          isp_num: row["ISP契約番号"],
          nuro_id: n_id,
          category: row["カテゴリー"],
          name: row["企画セット名称"],
          service: row["サービス名"],
          price: row["単価"],
          payment: row["入金日"]
        )
        errors << "#{index}行目,店舗名「#{row["店舗名"]}」保存できませんでした" if nuro.invalid? && errors.length < 5
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
      nuro = Nuro.find_by(isp_num: row["ISP契約番号"]) 
      n_id = nuro.id if nuro.present?
      nuro_payment = find_by(isp_num: row["ISP契約番号"],service: row["サービス名"],payment: row["入金日"])
      if nuro_payment.present?
        nuro_payment.assign_attributes(
          isp_num: row["ISP契約番号"],
          nuro_id: n_id,
          category: row["カテゴリー"],
          name: row["企画セット名称"],
          service: row["サービス名"],
          price: row["単価"],
          payment: row["入金日"]
        )
        if nuro_payment.has_changes_to_save? 
          nuro_payment.save!
          update_cnt += 1
        else  
          nochange_cnt += 1
        end 
      else  
        nuro_payment = new(
          isp_num: row["ISP契約番号"],
          nuro_id: n_id,
          category: row["カテゴリー"],
          name: row["企画セット名称"],
          service: row["サービス名"],
          price: row["単価"],
          payment: row["入金日"]
          )
          nuro_payment.save!
        new_cnt += 1
      end
    end
    "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件"
  end 
  
end
