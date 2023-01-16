class SummitBillingAmount < ApplicationRecord
  require 'charlock_holmes'
  belongs_to :user 
  belongs_to :summit

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"])
      u_id = user.id rescue ''

      summit = Summit.find_by(record_num: row["レコード番号"].to_i)
      s_id = summit.id rescue ''
      errors << "#{index}行目の担当者名が存在しません。#{row["パートナー営業担当"]}" if user.blank? && errors.length < 5

        summit_billing_amount = new(
          first_flag: row["初回明細フラグ"],
          base: row["拠点"],
          prefecture: row["都道府県"],
          billing_date: row["請求対象年月"],
          store_name: row["屋号名"],
          contract_type: row["低圧料金メニュー"],
          total_use: row["当月使用量合計"],
          billing_amount: row["請求金額税込み（円"],
          commission: row["税抜"],
          commission_tax_included: row["手数料（円・税込）"],
          record_num: row["レコード番号"],
          payment_date: row["入金日"],
          user_id: u_id,
          summit_id: s_id,
          
          
        )
        errors << "#{index}行目,屋号名「#{row["屋号名"]}」保存できませんでした" if summit_billing_amount.invalid? && errors.length < 5
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
      u_id = user.id rescue ''
      summit = Summit.find_by(record_num: row["レコード番号"].to_i)
      s_id = summit.id rescue ''
      summit_billing_amount = 
        SummitBillingAmount.find_by(billing_date: row["請求対象年月"],record_num: row["レコード番号"])
    if summit_billing_amount.present? 
      summit_billing_amount.assign_attributes(
        first_flag: row["初回明細フラグ"],
        base: row["拠点"],
        prefecture: row["都道府県"],
        billing_date: row["請求対象年月"],
        store_name: row["屋号名"],
        contract_type: row["低圧料金メニュー"],
        total_use: row["当月使用量合計"],
        billing_amount: row["請求金額税込み（円"],
        commission: row["税抜"],
        commission_tax_included: row["手数料（円・税込）"],
        record_num: row["レコード番号"],
        payment_date: row["入金日"],
        user_id: u_id,
        summit_id: s_id,
      )
      if summit_billing_amount.has_changes_to_save? 
        summit_billing_amount.save!
        update_cnt += 1
      else  
        nochange_cnt += 1
      end 
    else  
      summit_billing_amount = new(
        first_flag: row["初回明細フラグ"],
        base: row["拠点"],
        prefecture: row["都道府県"],
        billing_date: row["請求対象年月"],
        store_name: row["屋号名"],
        contract_type: row["低圧料金メニュー"],
        total_use: row["当月使用量合計"],
        billing_amount: row["請求金額税込み（円"],
        commission: row["税抜"],
        commission_tax_included: row["手数料（円・税込）"],
        record_num: row["レコード番号"],
        payment_date: row["入金日"],
        user_id: u_id,
        summit_id: s_id,
        )
        summit_billing_amount.save!
      new_cnt += 1
    end
  end
  "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件 "
  end

  def payment_month
    self.payment_date.month
  end 

end
