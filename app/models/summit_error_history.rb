class SummitErrorHistory < ApplicationRecord

  belongs_to :user
  with_options presence: true do 
    validates :store_name
    validates :status
    validates :user_id
    validates :target_record_num
  end 

  def self.csv_check(file)
    errors = []
    CSV.foreach(file.path, headers: true).with_index(1) do |row, index|
      user = User.find_by(name: row["パートナー営業担当"])
      u_id = user.id rescue ''
      errors << "#{index}行目の担当者名が存在しません。#{row["パートナー営業担当"]}" if user.blank? && errors.length < 5

        summit = new(
          start_section: row["レコードの開始行"],
          error_record_num: row["エラー_レコード番号"],
          store_name: row["契約者ー法人名（漢字）"],
          status: row["対応ステータス"],
          error_class: row["エラー区分1"],
          error_class2: row["エラー区分2"],
          not_payment_month: row["未入金_対象月"],
          price: row["電気料金（税込）"],
          arrears_flag: row["延滞金[あり]"],
          arrears_contains: row["延滞金[合算請求]"],
          payment: row["入金日"],
          next_response: row["次回対応日"],
          response_remarks: row["次回対応メモ"],
          user_id: u_id,
          next_response_user: row["次回対応者"],
          summit_user: row["旧サミット事務担当"],
          create_datetime: row["作成日時"],
          target_record_num: row["対象案件_レコード番号"],
          create_date: row["作成"],
          input_user: row["入力・対応者"],
          response_place: row["対応先"],
          response_method: row["対応手段"],
          next_request: row["対応内容⇒次回依頼"]
          
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
      user = User.find_by(name: row["パートナー営業担当"])
      u_id = user.id rescue ''
      summit = SummitErrorHistory.find_by(error_record_num: row["エラー_レコード番号"],create_date: row["作成"])
    if summit.present? 
      summit.assign_attributes(
        start_section: row["レコードの開始行"],
        error_record_num: row["エラー_レコード番号"],
        store_name: row["契約者ー法人名（漢字）"],
        status: row["対応ステータス"],
        error_class: row["エラー区分1"],
        error_class2: row["エラー区分2"],
        not_payment_month: row["未入金_対象月"],
        price: row["電気料金（税込）"],
        arrears_flag: row["延滞金[あり]"],
        arrears_contains: row["延滞金[合算請求]"],
        payment: row["入金日"],
        next_response: row["次回対応日"],
        response_remarks: row["次回対応メモ"],
        user_id: u_id,
        next_response_user: row["次回対応者"],
        summit_user: row["旧サミット事務担当"],
        create_datetime: row["作成日時"],
        target_record_num: row["対象案件_レコード番号"],
        create_date: row["作成"],
        input_user: row["入力・対応者"],
        response_place: row["対応先"],
        response_method: row["対応手段"],
        next_request: row["対応内容⇒次回依頼"]
      )
      if summit.has_changes_to_save? 
        summit.save!
        update_cnt += 1
      else  
        nochange_cnt += 1
      end 
    else  
      summit = new(
        start_section: row["レコードの開始行"],
        error_record_num: row["エラー_レコード番号"],
        store_name: row["契約者ー法人名（漢字）"],
        status: row["対応ステータス"],
        error_class: row["エラー区分1"],
        error_class2: row["エラー区分2"],
        not_payment_month: row["未入金_対象月"],
        price: row["電気料金（税込）"],
        arrears_flag: row["延滞金[あり]"],
        arrears_contains: row["延滞金[合算請求]"],
        payment: row["入金日"],
        next_response: row["次回対応日"],
        response_remarks: row["次回対応メモ"],
        user_id: u_id,
        next_response_user: row["次回対応者"],
        summit_user: row["旧サミット事務担当"],
        create_datetime: row["作成日時"],
        target_record_num: row["対象案件_レコード番号"],
        create_date: row["作成"],
        input_user: row["入力・対応者"],
        response_place: row["対応先"],
        response_method: row["対応手段"],
        next_request: row["対応内容⇒次回依頼"]
        )
      summit.save!
      new_cnt += 1
    end
  end
  "新規登録#{new_cnt}件, 更新#{update_cnt}件, 変更なし#{nochange_cnt}件 "
  end



end
