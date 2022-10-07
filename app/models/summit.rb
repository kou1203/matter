class Summit < ApplicationRecord
  belongs_to :store_prop
  belongs_to :user


  with_options presence: true do
    validates :store_prop_id
    validates :user_id 
    validates :control_num
    validates :date
    validates :store_name  
    validates :contract_type
    validates :supply_num 
    validates :status
  end 

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["獲得者"])
      store_prop = StoreProp.find_by(phone_number_1: row["連絡先（-あり）"],name: row["屋号名"])
      errors << "#{index}行目獲得者が不正です" if user.blank? && errors.length < 5
      errors << "#{index}行目屋号名が不正です" if store_prop.blank? && errors.length < 5
        store_id = store_prop.id if store_prop.present? 
        summit = new(
          processing_status: row["処理状況"],
          control_num: row["管理番号"],
          store_prop_id: store_id,
          store_name: row["屋号名"],
          date: row["獲得日"],
          user_id: user.id,
          power_company: row["電力会社"],
          power_company_other: row["電力会社その他"],
          power_area: row["電力エリア"],
          plan: row["プラン名"],
          contract_type: row["契約種別"],
          contract_cap: row["契約容量（数量）"],
          contract_cap_unit: row["契約容量（単位）"],
          use_start: row["使用期間（開始）"],
          use_end: row["使用期間（区切）"],
          amount_use: row["使用量（kWh）"],
          processing_date: row["事務処理日"],
          arrival_date: row["サミット到着日"],
          summit_start: row["利用開始日"],
          customer_num: row["お客様番号（14桁）"],
          supply_num: row["供給地点番号（22桁）"],
          current_contractor: row["現契約名義（漢字）"],
          current_contractor_kana: row["現契約名義（カタカナ）"],
          new_contractor: row["新契約名義（漢字）"],
          new_contractor_kana: row["新契約名義（カタカナ）"],
          store_name_kana: row["屋号名（カタカナ）"],
          destination_item: row["宛名"],
          destination_name: row["宛名（漢字）"],
          destination_name_kana: row["宛名（カタカナ）"],
          billing_item: row["請求担当者①"],
          billing_name: row["請求担当者①（漢字）"],
          billing_name_kana: row["請求担当者①（カタカナ）"],
          billing_name_mail: row["請求担当者①（メールアドレス）"],
          crepiko_num: row["クレピコお客様番号"],
          remarks: row["備考"],
          fc_num: row["FC番号"],
          mail_send: row["メール送付"],
          status: row["現状ステータス"],
        )
        errors << "#{index}行目,屋号名「#{row["屋号名"]}」保存できませんでした" if summit.invalid? && errors.length < 5
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
    store_prop = StoreProp.find_by(phone_number_1: row["連絡先（-あり）"],name: row["屋号名"])
    store_id = store_prop.id if store_prop.present? 
    summit = find_by(supply_num: row["供給地点番号（22桁）"])
    if summit.present? 
      summit.assign_attributes(
        processing_status: row["処理状況"],
        control_num: row["管理番号"],
        store_prop_id: store_id,
        store_name: row["屋号名"],
        date: row["獲得日"],
        user_id: user.id,
        power_company: row["電力会社"],
        power_company_other: row["電力会社その他"],
        power_area: row["電力エリア"],
        plan: row["プラン名"],
        contract_type: row["契約種別"],
        contract_cap: row["契約容量（数量）"],
        contract_cap_unit: row["契約容量（単位）"],
        use_start: row["使用期間（開始）"],
        use_end: row["使用期間（区切）"],
        amount_use: row["使用量（kWh）"],
        processing_date: row["事務処理日"],
        arrival_date: row["サミット到着日"],
        summit_start: row["利用開始日"],
        customer_num: row["お客様番号（14桁）"],
        supply_num: row["供給地点番号（22桁）"],
        current_contractor: row["現契約名義（漢字）"],
        current_contractor_kana: row["現契約名義（カタカナ）"],
        new_contractor: row["新契約名義（漢字）"],
        new_contractor_kana: row["新契約名義（カタカナ）"],
        store_name_kana: row["屋号名（カタカナ）"],
        destination_item: row["宛名"],
        destination_name: row["宛名（漢字）"],
        destination_name_kana: row["宛名（カタカナ）"],
        billing_item: row["請求担当者①"],
        billing_name: row["請求担当者①（漢字）"],
        billing_name_kana: row["請求担当者①（カタカナ）"],
        billing_name_mail: row["請求担当者①（メールアドレス）"],
        crepiko_num: row["クレピコお客様番号"],
        remarks: row["備考"],
        fc_num: row["FC番号"],
        mail_send: row["メール送付"],
        status: row["現状ステータス"],
      )
      if summit.has_changes_to_save? 
        summit.save!
        summit.assign_attributes(status_update: Date.today)
        update_cnt += 1
      else  
        nochange_cnt += 1
      end 
    else  
      summit = new(
        processing_status: row["処理状況"],
        control_num: row["管理番号"],
        store_prop_id: store_id,
        store_name: row["屋号名"],
        date: row["獲得日"],
        user_id: user.id,
        power_company: row["電力会社"],
        power_company_other: row["電力会社その他"],
        power_area: row["電力エリア"],
        plan: row["プラン名"],
        contract_type: row["契約種別"],
        contract_cap: row["契約容量（数量）"],
        contract_cap_unit: row["契約容量（単位）"],
        use_start: row["使用期間（開始）"],
        use_end: row["使用期間（区切）"],
        amount_use: row["使用量（kWh）"],
        processing_date: row["事務処理日"],
        arrival_date: row["サミット到着日"],
        summit_start: row["利用開始日"],
        customer_num: row["お客様番号（14桁）"],
        supply_num: row["供給地点番号（22桁）"],
        current_contractor: row["現契約名義（漢字）"],
        current_contractor_kana: row["現契約名義（カタカナ）"],
        new_contractor: row["新契約名義（漢字）"],
        new_contractor_kana: row["新契約名義（カタカナ）"],
        store_name_kana: row["屋号名（カタカナ）"],
        destination_item: row["宛名"],
        destination_name: row["宛名（漢字）"],
        destination_name_kana: row["宛名（カタカナ）"],
        billing_item: row["請求担当者①"],
        billing_name: row["請求担当者①（漢字）"],
        billing_name_kana: row["請求担当者①（カタカナ）"],
        billing_name_mail: row["請求担当者①（メールアドレス）"],
        crepiko_num: row["クレピコお客様番号"],
        remarks: row["備考"],
        fc_num: row["FC番号"],
        mail_send: row["メール送付"],
        status: row["現状ステータス"],
        )
      summit.save!
      new_cnt += 1
    end
  end
  "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件 "
  end

end