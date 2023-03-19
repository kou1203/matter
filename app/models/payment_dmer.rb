class PaymentDmer < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :dmer , optional: true
  with_options presence: true do 
    validates :payment
  end 

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
        product = new(
          controll_num: row["管理番号"],
          customer_num: row["申込番号"],
          store_code: row["店舗コード"],
          store_name: row["店舗名"],
          date: row["キャリアET日"],
          result_point: row["審査完了日"],
          settlement: row["初回決済日"],
          result_category: row["種類"],
          picture_done: row["アクセプタンスキャリア確認日"],
          settlement_second: row["2回目決済日"],
          payment: row["入金日"],
          price: row["手数料額"],
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
      product = find_by(controll_num: row["管理番号"],result_category: row["種類"])
        d_id = Dmer.find_by(controll_num: row["管理番号"]).id rescue ""
      if product.present?
        product.assign_attributes(
          dmer_id: d_id,
          controll_num: row["管理番号"],
          customer_num: row["申込番号"],
          store_code: row["店舗コード"],
          store_name: row["店舗名"],
          date: row["キャリアET日"],
          result_point: row["審査完了日"],
          settlement: row["初回決済日"],
          result_category: row["種類"],
          picture_done: row["アクセプタンスキャリア確認日"],
          settlement_second: row["2回目決済日"],
          payment: row["入金日"],
          price: row["手数料額"],
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
          dmer_id: d_id,
          controll_num: row["管理番号"],
          customer_num: row["申込番号"],
          store_code: row["店舗コード"],
          store_name: row["店舗名"],
          date: row["キャリアET日"],
          result_point: row["審査完了日"],
          settlement: row["初回決済日"],
          result_category: row["種類"],
          picture_done: row["アクセプタンスキャリア確認日"],
          settlement_second: row["2回目決済日"],
          payment: row["入金日"],
          price: row["手数料額"],
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
